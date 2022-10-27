//
//  ObservableWraper.swift
//  
//
//  Created by 庄黛淳华 on 2022/10/22.
//

import SwiftUI

@propertyWrapper
public class ObservableWraper<Value>: ObservableObject {
	@Published
	public var wrappedValue: Value

	public init(initialValue: Value) {
		self.wrappedValue = initialValue
	}

	public init(wrappedValue: Value) {
		self.wrappedValue = wrappedValue
	}
}
