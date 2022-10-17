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

	public func whenAnimationCompletion(_ completionClosure: @escaping () -> Void) {
		DispatchQueue.main.async {
			CATransaction.begin()
			CATransaction.setCompletionBlock(completionClosure)
			CATransaction.commit()
		}
	}

	@inlinable
	@ViewBuilder
	public func scrollable(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, scrollReader: ((ScrollViewProxy) -> Void)? = nil) -> some View {
		if let scrollReader {
			ScrollViewReader {
				if scrollReader($0) != () {

				} else {
					ScrollView(axes, showsIndicators: showsIndicators) { self }
				}
			}
		} else {
			ScrollView(axes, showsIndicators: showsIndicators) { self }
		}
	}

	@inlinable
	@ViewBuilder
	public func navigable() -> some View {
		if #available(iOS 16.0, macOS 13.0, *) {
			NavigationStack  {
				self
			}
		} else {
			NavigationView {
				self
			}
		}
	}
}
