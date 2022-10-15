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
		let r = (hex & 0xff0000) >> 16
		let g = (hex & 0xff00) >> 8
		let b = hex & 0xff

		self.init(
			red: CGFloat(r) / 0xff,
			green: CGFloat(g) / 0xff,
			blue: CGFloat(b) / 0xff,
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
