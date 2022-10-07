//
//  StringTest.swift
//
//
//  Created by 庄黛淳华 on 2022/5/4.
//

import XCTest
import class Foundation.Bundle
@testable import Extension

final class StringTest: XCTestCase {
	func test_ne_enumerateLines() throws {
		let testStrings = [
			"\n\n1\n2\n\n3\n4",
			"1\n2\n3\n",
			"\n1\n2\n\n3\n\n"
		]
		var result = [[String]]()

		// test enumerateLines
		result = []
		for testString in testStrings {
			var temp = [String]()
			testString.ne_enumerateLines(includingEmpty: true) { string, _ in
				temp.append(String(string))
			}
			result.append(temp)
		}
		XCTAssert(result == [
			["", "", "1", "2", "", "3", "4"],
			["1", "2", "3", ""],
			["", "1", "2", "", "3", "", ""]
		])

		// test not includingEmpty
		result = []
		for testString in testStrings {
			var temp = [String]()
			testString.ne_enumerateLines(includingEmpty: false) { string, _ in
				temp.append(String(string))
			}
			result.append(temp)
		}
		XCTAssert(result == [
			["1", "2", "3", "4"],
			["1", "2", "3"],
			["1", "2", "3"]
		])
	}
}
