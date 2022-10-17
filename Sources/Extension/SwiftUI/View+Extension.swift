//
//  View+Extension.swift
//  
//
//  Created by 庄黛淳华 on 2022/10/16.
//

import SwiftUI

extension View {
	@inlinable
	@_disfavoredOverload
	// swiftlint:disable attributes
	public func task(priority: TaskPriority = .userInitiated, _ action: @escaping @Sendable () async throws -> Void) -> some View {
		self.task(priority: priority) {
			do {
				try await action()
			} catch {
			}
		}
	}

	@inline(never)
	@ViewBuilder
	public func `if`(@ViewBuilder testCase: (Self) -> some View) -> some View {
		let view = testCase(self)

		if (view as? _Optional)?.isNil == true {
			self
		} else {
			view
		}
	}
}
