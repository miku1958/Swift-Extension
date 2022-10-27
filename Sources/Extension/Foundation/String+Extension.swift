//
//  File.swift
//
//
//  Created by 庄黛淳华 on 2021/11/18.
//

import Foundation

extension StringProtocol {
	public func quoted(singleQuoted: Bool = false, escapeEscapeCharacter: Bool = false) -> String {
		let quote = singleQuoted ? "'" : "\""
		if escapeEscapeCharacter {
			return #"\"# + quote + self + #"\"# + quote
		} else {
			return quote + self + quote
		}
	}

	public func removePrefixIfHas(_ prefix: String) -> String? {
		guard self.hasPrefix(prefix) else {
			return nil
		}
		var string = String(self)
		string.removeFirst(prefix.count)
		return string
	}

	public func removeSuffixIfHas(_ suffix: String) -> String? {
		guard self.hasSuffix(suffix) else {
			return nil
		}
		var string = String(self)
		string.removeLast(suffix.count)
		return string
	}

	public func indent(level: Int) -> String {
		if level > 0 {
			let indents = String(repeating: "\t", count: level)
			return indents + self.replacingOccurrences(of: "\n", with: "\n" + indents)
		}
		var temp = String(self)
		if level < 0 {
			for _ in level..<0 {
				if temp.hasPrefix("\t") {
					temp.removeFirst()
				}
				temp = temp.replacingOccurrences(of: "\n\t", with: "\n")
			}
		}
		return temp
	}

	@inlinable
	public func split(at index: Index) -> (first: String, second: String) {
		let first = self[..<index]
		let second = self[self.index(after: index)...]
		return (String(first), String(second))
	}

	public func replacingWithRegularExpression(of rex: String, with replacement: String) -> [String] {
		do {
			var result = [String]()
			let expression = try NSRegularExpression(pattern: rex, options: [])
			let string = String(self)

			expression.enumerateMatches(in: string, options: [], range: NSRange(location: 0, length: string.count)) { rexResult, _, _ in
				guard let rexResult = rexResult else {
					return
				}

				let newString = expression.stringByReplacingMatches(in: string, options: [], range: rexResult.range, withTemplate: replacement)
				result.append(newString)
			}
			return result
		} catch {
			return []
		}
	}

	/// non-escaping version enumerateLines
	public func ne_enumerateLines(includingEmpty: Bool = true, invoking body: (SubSequence, inout Bool) -> Void) {
		var startIndex = self.startIndex
		var endIndex = startIndex
		let newLineSet = CharacterSet.newlines

		var stop = false
		while !stop, endIndex != self.endIndex {
			if newLineSet.contains(self.unicodeScalars[endIndex]) {
				let subString = self[startIndex..<endIndex]
				if !subString.isEmpty || (subString.isEmpty && includingEmpty) {
					body(subString, &stop)
				}
				startIndex = self.index(after: endIndex)
				endIndex = startIndex
			} else {
				endIndex = self.index(after: endIndex)
			}
		}
		let subString = self[startIndex..<endIndex]
		if !subString.isEmpty || (subString.isEmpty && includingEmpty) {
			body(subString, &stop)
		}
	}

	@_disfavoredOverload
	public subscript(range: Range<Index>) -> String {
		String(self[range])
	}

	@_disfavoredOverload
	public subscript<R>(range: R) -> String where R: RangeExpression, Index == R.Bound {
		String(self[range])
	}
}

extension String {
	public mutating func appendLine(_ string: String) {
		if self.isEmpty {
			self = string
		} else {
			self.append("\n\(string)")
		}
	}

	public static func readLine(for filePath: String, invoke body: (_ line: String, _ stop: inout Bool) -> Void) {
		let filePtr = fopen(filePath, "r")
		var linePtr: UnsafeMutablePointer<CChar>?
		var linecap: Int = 0
		var stop = false

		let newlines = CharacterSet.newlines
		while !stop, getline(&linePtr, &linecap, filePtr) > 0, let line = linePtr {
			var line = String(cString: line)
			if let last = line.unicodeScalars.last, newlines.contains(last) {
				line.removeLast()
			}
			body(line, &stop)
		}

		if let line = linePtr {
			free(line)
		}
		fclose(filePtr)
	}
}

extension Optional where Wrapped == String {
	public func format(formatter: (String) -> String) -> String {
		guard let string = self else { return "" }
		return formatter(string)
	}
}
