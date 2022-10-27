//
//  Color+Extension.swift
//  Splatoon3 Gear Manager
//
//  Created by 庄黛淳华 on 2022/10/12.
//

import Foundation
import SwiftUI

extension Color {
	public init(hex: UInt64) {
		let red = (hex & 0xff0000) >> 16
		let green = (hex & 0xff00) >> 8
		let blue = hex & 0xff

		self.init(
			red: CGFloat(red) / 0xff,
			green: CGFloat(green) / 0xff,
			blue: CGFloat(blue) / 0xff,
			opacity: 1
		)
	}

	public init(hex: String) {
		let scanner = Scanner(string: hex)
		scanner.currentIndex = hex.startIndex
		var hexValue: UInt64 = 0
		scanner.scanHexInt64(&hexValue)
		self.init(hex: hexValue)
	}
}
