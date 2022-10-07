//
//  TaskOperation.swift
//
//
//  Created by 庄黛淳华 on 2022/7/5.
//

import Foundation

public class TaskOperation: Operation {
	var task: Task<Void, Swift.Error>?

	private var _isFinished: Bool = false {
		willSet {
			willChangeValue(for: \.isFinished)
		}
		didSet {
			didChangeValue(for: \.isFinished)
		}
	}

	private var _isExecuting: Bool = false {
		willSet {
			willChangeValue(for: \.isExecuting)
		}
		didSet {
			didChangeValue(for: \.isExecuting)
		}
	}

	override public var isFinished: Bool {
		_isFinished
	}

	override public var isConcurrent: Bool {
		true
	}

	override public var isAsynchronous: Bool {
		false
	}

	override public var isReady: Bool {
		true
	}

	var executionBlocks: [() async throws -> Void] = []

	// swiftlint:disable attributes
	public convenience init(block: @escaping @Sendable () async throws -> Void) {
		self.init()
		executionBlocks.append(block)
	}

	override public func start() {
		guard !isCancelled else {
			return
		}

		for dependency in dependencies {
			dependency.waitUntilFinished()
		}
		_isExecuting = true

		task = Task {
			defer {
				_isExecuting = false
				_isFinished = true
				task = nil
			}
			guard !isCancelled else {
				return
			}
			for block in executionBlocks {
				try await block()
			}
		}
	}
	override public func cancel() {
		super.cancel()
		task?.cancel()
		task = nil
		_isFinished = true
	}
}

extension OperationQueue {
	public func addTaskOperation(_ block: @escaping @Sendable () async throws -> Void) {
		addOperation(TaskOperation(block: block))
	}
}
