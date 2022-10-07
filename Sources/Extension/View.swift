//
//  View.swift
//
//
//  Created by 庄黛淳华 on 2022/7/23.
//

import Foundation
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
}
