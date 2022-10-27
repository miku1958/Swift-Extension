//
//  Binding+Extension.swift
//  
//
//  Created by 庄黛淳华 on 2022/10/20.
//

import SwiftUI

extension Binding {
	@inlinable
	public func optional() -> Binding<Value?> {
		.init(get: {
			self.wrappedValue
		}, set: {
			if let newValue = $0 {
				self.wrappedValue = newValue
			}
		})
	}

	@inlinable
	public func wrapped<Wrapped>(defaultValue: @autoclosure @escaping () -> Wrapped) -> Binding<Wrapped> where Value == Wrapped? {
		.init(get: {
			let value = self.wrappedValue ?? defaultValue()
			if self.wrappedValue == nil {
				DispatchQueue.main.async {
					if self.wrappedValue == nil {
						withAnimation(nil) {
							self.wrappedValue = value
						}
					}
				}
			}

			return value
		}, set: {
			self.wrappedValue = $0
		})
	}

	@_disfavoredOverload
	public subscript<Subject>(dynamicMember keyPath: Swift.WritableKeyPath<Value, Subject>) -> Binding<Subject?> {
		self[dynamicMember: keyPath].optional()
	}

	@inlinable
	public func map<P>(_ keyPath: WritableKeyPath<Value, P>) -> Binding<P> {
		.init {
			self.wrappedValue[keyPath: keyPath]
		} set: {
			self.wrappedValue[keyPath: keyPath] = $0
		}
	}

	@inlinable
	public static func notify<P>(_ source: Binding<P>, notification: @escaping (_ newValue: P) -> Void) -> Binding<P> {
		.init {
			source.wrappedValue
		} set: {
			source.wrappedValue = $0
			notification($0)
		}
	}
}

extension Binding where Value == Void {
	public init(set: @escaping () -> Void) {
		self.init(get: { }, set: set)
	}
}
