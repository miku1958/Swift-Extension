//
//  Optional.swift
//
//
//  Created by 庄黛淳华 on 2022/7/23.
//

import Foundation

protocol _Optional {
	var isNil: Bool { get }
}

extension Optional: _Optional {
	var isNil: Bool {
		self == nil
	}
}

infix operator ???: NilCoalescingPrecedence

public func ??? <T>(optional: T?, defaultValue: @autoclosure () async throws -> T) async rethrows -> T {
	if let optional {
		return optional
	} else {
		return try await defaultValue()
	}
}

public func ??? <T>(optional: T?, defaultValue: @autoclosure () async throws -> T?) async rethrows -> T? {
	if let optional {
		return optional
	} else {
		return try await defaultValue()
	}
}
