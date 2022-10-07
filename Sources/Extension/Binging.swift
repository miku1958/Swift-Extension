//
//  File.swift
//
//
//  Created by 庄黛淳华 on 2021/12/10.
//

import SwiftUI

extension Binding where Value: Equatable {
	public static func proxy(_ source: Binding<Value>) -> Binding<Value> {
		self.init(
			get: { source.wrappedValue },
			set: { source.wrappedValue = $0 }
		)
	}
}

extension Binding where Value == Void {
	public init(set: @escaping () -> Void) {
		self.init {
		} set: { _ in
			set()
		}
	}
}
