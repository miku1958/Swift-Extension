//
//  MainActor.swift
//
//
//  Created by 庄黛淳华 on 2022/6/15.
//

import Foundation

extension MainActor {
	@MainActor
	@discardableResult
	public static func run<O, P>(_ owner: O, action: @MainActor (O) throws -> P) rethrows -> P {
		try action(owner)
	}
}
