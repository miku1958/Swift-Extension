//
//  SeparateLine.swift
//
//
//  Created by 庄黛淳华 on 2022/4/3.
//

import SwiftUI

public struct SeparateLine: View {
	let color: Color
	public enum Direction {
		case horizontal
		case vertical
	}
	let direction: Direction

	public init(color: Color = .gray, direction: Direction = .horizontal) {
		self.color = color
		self.direction = direction
	}

	public var body: some View {
		if direction == .vertical {
			color.frame(width: 1)
		} else {
			color.frame(height: 1)
		}
	}
}

struct SeparateLineView_Previews: PreviewProvider {
	static var previews: some View {
		SeparateLine(color: .gray, direction: .vertical)
	}
}
