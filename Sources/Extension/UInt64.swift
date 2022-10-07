//
//  UInt64.swift
//
//
//  Created by 庄黛淳华 on 2022/8/2.
//

import Foundation

extension UInt64 {
	public static func second<T>(_ sec: T) -> UInt64 where T: BinaryFloatingPoint {
		UInt64(sec * 1_000_000_000)
	}

	public static func second<T>(_ sec: T) -> UInt64 where T: BinaryInteger {
		UInt64(sec * 1_000_000_000)
	}

	public static func second() -> UInt64 {
		1_000_000_000
	}

	public static func min<T>(_ min: T) -> UInt64 where T: BinaryFloatingPoint {
		.second(min * 60)
	}

	public static func min<T>(_ min: T) -> UInt64 where T: BinaryInteger {
		.second(min * 60)
	}

	public static func min() -> UInt64 {
		.second(60)
	}

	public static func hour<T>(_ hour: T) -> UInt64 where T: BinaryFloatingPoint {
		.min(hour * 60)
	}

	public static func hour<T>(_ hour: T) -> UInt64 where T: BinaryInteger {
		.min(hour * 60)
	}

	public static func hour() -> UInt64 {
		.min(60)
	}
}
