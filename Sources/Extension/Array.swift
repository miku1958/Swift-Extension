//
//  Array.swift
//
//
//  Created by 庄黛淳华 on 2022/7/23.
//

import Foundation

extension Array {
	@inlinable
	public func concurrentMap<T: Sendable>(_ transform: @escaping (Element) async throws -> T, concurrent: Bool = false) async rethrows -> [T] {
		try await withThrowingTaskGroup(of: T.self, body: { group in
			for item in self {
				group.addTask {
					try await transform(item)
				}
			}
			var result = [T]()
			while let value = try await group.next() {
				result.append(value)
			}
			return result
		})
	}

	@inlinable
	@_disfavoredOverload
	public func map<T: Sendable>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
		var result = [T]()
		for item in self {
			result.append(try await transform(item))
		}
		return result
	}

	@inlinable
	public func concurrentCompactMap<ElementOfResult>(_ transform: @escaping (Element) async throws -> ElementOfResult?) async rethrows -> [ElementOfResult] {
		try await withThrowingTaskGroup(of: ElementOfResult?.self, body: { group in
			for item in self {
				group.addTask {
					try await transform(item)
				}
			}
			var result = [ElementOfResult]()

			while let value = try await group.next() {
				if let value {
					result.append(value)
				}
			}
			return result
		})
	}

	@inlinable
	@_disfavoredOverload
	public func compactMap<ElementOfResult>(_ transform: (Element) async throws -> ElementOfResult?) async rethrows -> [ElementOfResult] {
		var result = [ElementOfResult]()
		for item in self {
			if let value = try await transform(item) {
				result.append(value)
			}
		}
		return result
	}
}
