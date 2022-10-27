//
//  ExpandingView.swift
//
//
//  Created by 庄黛淳华 on 2022/6/3.
//

import SwiftUI

extension HorizontalAlignment {
	fileprivate var needLeadingSpace: Bool {
		switch self {
		case .leading: return false
		case .center: return true
		case .trailing: return true
		default: return false
		}
	}
	fileprivate var needTrailingSpace: Bool {
		switch self {
		case .leading: return true
		case .center: return true
		case .trailing: return false
		default: return false
		}
	}
}

extension VerticalAlignment {
	fileprivate var needTopSpace: Bool {
		switch self {
		case .top: return false
		case .center: return true
		case .bottom: return true
		default: return false
		}
	}

	fileprivate var needBottomSpace: Bool {
		switch self {
		case .top: return true
		case .center: return true
		case .bottom: return false
		default: return false
		}
	}
}

public struct ExpandingView<Content>: View where Content: View {
	let horizontal: HorizontalAlignment?
	let vertical: VerticalAlignment?
	let content: () -> Content

	public init(aligment: Alignment = Alignment(horizontal: .center, vertical: .center), @ViewBuilder content: @escaping () -> Content) {
		self.horizontal = aligment.horizontal
		self.vertical = aligment.vertical
		self.content = content
	}

	public init(horizontal: HorizontalAlignment?, vertical: VerticalAlignment?, @ViewBuilder content: @escaping () -> Content) {
		self.horizontal = horizontal
		self.vertical = vertical
		self.content = content
	}

	public var body: some View {
		HStack(alignment: vertical ?? .center, spacing: 0) {
			if let horizontal, horizontal.needLeadingSpace {
				Spacer()
			}
			VStack(alignment: horizontal ?? .center, spacing: 0) {
				if let vertical, vertical.needTopSpace {
					Spacer()
				}
				content()
				if let vertical, vertical.needBottomSpace {
					Spacer()
				}
			}
			if let horizontal, horizontal.needTrailingSpace {
				Spacer()
			}
		}
	}
}

struct ExpandingView_Previews: PreviewProvider {
	static var previews: some View {
		ExpandingView {
			Color.red.frame(width: 5, height: 5)
		}.frame(width: 10, height: 10)
	}
}
