//
//  CollectionDifference.swift
//
//
//  Created by 庄黛淳华 on 2022/8/6.
//

import Foundation

extension Array {
	public func values<ChangeElement>() -> [ChangeElement] where Element == CollectionDifference<ChangeElement>.Change {
		map {
			switch $0 {
			case let .insert(_, element, _):
				return element

			case let .remove(_, element, _):
				return element
			}
		}
	}
}
