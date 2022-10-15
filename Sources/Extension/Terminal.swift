//
//  File.swift
//  
//
//  Created by 庄黛淳华 on 2022/10/7.
//

import Foundation

#if os(macOS)
public enum Terminal {
	public struct Environment {
		var launchPath: String
		var arguments: (_ command: String) -> [String]

		public static var bash: Environment {
			.init(launchPath: "/bin/bash", arguments: { ["-c", $0] })
		}

		public static var zsh: Environment {
			.init(launchPath: "/bin/zsh", arguments: { ["-c", $0] })
		}

		public static var none: Environment {
			.init(launchPath: "", arguments: { _ in [] })
		}

		typealias Process = (launchPath: String, arguments: [String])
		func env(command: String) async throws -> Process {
			if !launchPath.isEmpty {
				return (launchPath, arguments(command))
			}
			let commands = command.split(separator: " ")
			var launchPath = ""
			var arguments = [String]()
			if !commands.isEmpty {
				try await Terminal.run(command: "which \(commands[0])", progress: .block {
					launchPath = $0
				})
			}
			if commands.count > 1 {
				try await Terminal.run(command: "echo " + commands[1...].joined(separator: " "), enviroment: .bash, progress: .block {
					arguments = $0.split(separator: " ").map(String.init)
				})
			}
			return (launchPath, arguments)
		}
	}
	public enum Progress {
		public typealias Block = (_ text: String) -> Void
		public enum ScriptOption: Equatable {
			case login
			case delay(_ timeinterval: TimeInterval)
			case waitUntilFinish
			case closeScriptInside
		}
		// use stdout
		case print
		case block(output: Block, error: Block? = nil)
	}

	public enum Option {
		case reportCompletion
		case splitWithNewLine
		case trimming(CharacterSet)
	}

	public class AsyncProcess {
		fileprivate let progress: Progress
		fileprivate let options: [Option]

		fileprivate private(set) var process: Process? = Process()
		fileprivate var isWaiting = false

		static let updateRunningCommandLock = NSLock()
		public static var runningProcesses = [AsyncProcess]()

		private var outPipe: Pipe?
		private var outCache = ""
		public var outputResult = ""

		private var errorPipe: Pipe?
		public var errorResult = ""

		private var _inputPipe: Pipe?
		fileprivate var inputPipe: Pipe? {
			if state == .notLaunch, _inputPipe == nil {
				_inputPipe = Pipe()
				process?.standardInput = _inputPipe
			}
			return _inputPipe
		}

		enum State: Equatable {
			case notLaunch
			case running
			case terminated(status: Int, reason: Process.TerminationReason)
			case released
		}
		var state: State {
			guard let process = process else {
				return .released
			}
			if process.isRunning {
				return .running
			}

			var terminationReason: Process.TerminationReason?
			try? objc_try {
				terminationReason = process.terminationReason
			}
			if let terminationReason = terminationReason {
				return .terminated(status: Int(process.terminationStatus), reason: terminationReason)
			}

			return .notLaunch
		}

		fileprivate init(progress: Terminal.Progress, options: [Terminal.Option]) {
			self.progress = progress
			self.options = options

			Self.updateRunningCommandLock.lock()
			Self.runningProcesses.append(self)
			Self.updateRunningCommandLock.unlock()

			if case .block = progress {
				outPipe = Pipe()
				errorPipe = Pipe()
				if outPipe == nil {
					print("outPipe is nil!")
				}
				process?.standardOutput = outPipe
				process?.standardError = errorPipe
			}
		}

		func handlePipes() async throws {
			weak var process = self.process
			var workItem: DispatchWorkItem?
			func interruptLater() -> Bool {
				workItem?.cancel()
				workItem = DispatchWorkItem {
					process?.interrupt()
				}
				DispatchQueue.global().asyncAfter(deadline: .now() + 90, execute: workItem!)
				return true
			}

			func checkTask() -> Bool {
				withUnsafeCurrentTask { task in
					if task?.isCancelled == true {
						Task {
							try await self.forceCancel()
						}
						return false
					}
					return true
				}
			}

			while
				checkTask(),
				interruptLater(),
				let data = outPipe?.fileHandleForReading.availableData, !data.isEmpty
			{
				workItem?.cancel()
				try await handle(data: data, for: outPipe)
			}

			while
				checkTask(),
				interruptLater(),
				let data = errorPipe?.fileHandleForReading.availableData, !data.isEmpty
			{
				workItem?.cancel()
				try await handle(data: data, for: errorPipe)
			}

			workItem?.cancel()
		}

		func handle(data: Data, for pipe: Pipe?) async throws {
			guard var strs = String(data: data, encoding: String.Encoding.utf8), !strs.isEmpty else {
				return
			}

			if pipe == self.errorPipe {
				self.errorResult += strs
				return
			}
			if strs.hasSuffix("\n") {
				strs = self.outCache + strs
				self.outCache = ""
			} else {
				self.outCache += strs
				strs = ""
			}
			if strs.isEmpty {
				return
			}
			if self.options.reportCompletion {
				self.outputResult += strs
			} else if case let .block(output, error) = self.progress {
				let progress = (pipe == self.outPipe ? output : error) ?? output
				if self.options.splitWithNewLine {
					for str in strs.split(separator: "\n") {
						progress(str.trimmingCharacters(in: self.options.trimmingCharacterSet))
					}
				} else {
					progress(strs.trimmingCharacters(in: self.options.trimmingCharacterSet))
				}
			}
		}

		fileprivate func wait() async throws {
			if Thread.isMainThread {
				let stack = Thread.callStackSymbols
				let tempFile = NSTemporaryDirectory() + "/" + UUID().uuidString
				try stack.joined(separator: "\n").write(toFile: tempFile, atomically: true, encoding: .utf8)
			}
			guard isWaiting == false else { return }

			isWaiting = true

			try? process?.run()

			// Pipes need to be handled before waitUntilExit, otherwise process will never exit.
			try await handlePipes()
			process?.waitUntilExit()
			try await handlePipes()

			self.process = nil

			if case let .block(outputCall, errorCall) = progress {
				if options.reportCompletion {
					let output = outputResult.trimmingCharacters(in: options.trimmingCharacterSet)
					if !output.isEmpty {
						outputCall(output)
					}
				}
				let error = errorResult.trimmingCharacters(in: options.trimmingCharacterSet)
				if !error.isEmpty {
					(errorCall ?? outputCall)(error)
				}
			}

			Self.updateRunningCommandLock.lock()
			Self.runningProcesses.removeAll {
				$0 === self
			}
			Self.updateRunningCommandLock.unlock()

			try? outPipe?.fileHandleForReading.close()
			try? errorPipe?.fileHandleForReading.close()
			try? inputPipe?.fileHandleForWriting.close()
		}

		public func forceCancel() async throws {
			if let process = process {
				process.terminate()
			}
		}

		public var isRunning: Bool {
			state == .running
		}
	}

	public static func run(command: String, enviroment: Environment = .bash, progress: Progress = .print, input: String? = nil, options: [Option] = [.trimming(.whitespacesAndNewlines), .splitWithNewLine], threadIdentifier: String? = nil) async throws {
		var progress = progress
		if case .print = progress {
			progress = .block { text in
				print(text)
			}
		}

		let asyncProcess = AsyncProcess(progress: progress, options: options)

		let env: Environment.Process = try await enviroment.env(command: command)
		print("running command: \(command.quoted())")

		asyncProcess.process?.launchPath = env.launchPath
		asyncProcess.process?.arguments = env.arguments

		if let input = input?.data(using: .utf8), !input.isEmpty,
		   let handle = asyncProcess.inputPipe?.fileHandleForWriting {
			try? handle.write(contentsOf: input)
			try? handle.close()
		}

		try await asyncProcess.wait()
	}
}

extension Array where Element == Terminal.Option {
	var splitWithNewLine: Bool {
		self.contains {
			if case .splitWithNewLine = $0 {
				return true
			}
			return false
		}
	}
	var reportCompletion: Bool {
		self.contains {
			if case .reportCompletion = $0 {
				return true
			}
			return false
		}
	}

	var trimmingCharacterSet: CharacterSet {
		var characterSet = CharacterSet()
		self.compactMap { option -> CharacterSet? in
			if case let .trimming(set) = option {
				return set
			}
			return nil
		}
		.forEach {
			characterSet.formUnion($0)
		}
		return characterSet
	}
}
#endif
