//
//  Nanosecond.swift
//
//
//  Created by 庄黛淳华 on 2022/8/2.
//

import Foundation

public enum Nanosecond {
	public static func second() -> UInt64 {
		1_000_000_000
	}

	public static func min() -> UInt64 {
		Self.seconds(60)
	}

	public static func hour() -> UInt64 {
		Self.minutes(60)
	}

	public static func seconds<T>(_ sec: T) -> UInt64 where T: BinaryFloatingPoint {
		UInt64(sec * T(Self.second()))
	}

	public static func seconds<T>(_ sec: T) -> UInt64 where T: BinaryInteger {
		UInt64(sec * T(Self.second()))
	}

	public static func minutes<T>(_ min: T) -> UInt64 where T: BinaryFloatingPoint {
		Self.seconds(min * 60)
	}

	public static func minutes<T>(_ min: T) -> UInt64 where T: BinaryInteger {
		Self.seconds(min * 60)
	}

	public static func hours<T>(_ hour: T) -> UInt64 where T: BinaryFloatingPoint {
		Self.minutes(hour * 60)
	}

	public static func hours<T>(_ hour: T) -> UInt64 where T: BinaryInteger {
		Self.minutes(hour * 60)
	}
}
