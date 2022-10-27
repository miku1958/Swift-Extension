//
//  File.swift
//
//
//  Created by 庄黛淳华 on 2021/10/15.
//

import Foundation

extension OperationQueue {
	@_disfavoredOverload
	public func addOperation(_ operation: Operation?) {
		if let operation {
			addOperation(operation)
		}
	}
}

extension Operation {
	@_disfavoredOverload
	public func addDependency(_ operation: Operation?) {
		if let operation {
			addDependency(operation)
		}
	}
}
