//
//  SwiftUIView.swift
//  
//
//  Created by 庄黛淳华 on 2022/10/17.
//

import SwiftUI

public struct SideBarView<Content>: View where Content: View {
	let content: () -> Content
	public init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content
	}

	public var body: some View {
// #if os(macOS)
//		List {
//			content()
//				.listRowInsets(EdgeInsets())
//				.listRowBackground(Color.clear)
//		}
//		.listStyle(SidebarListStyle())
// #elseif os(iOS)
		LazyVStack {
			content()
		}
		.scrollable()
// #endif
	}
}

struct SideBarView_Previews: PreviewProvider {
	static var previews: some View {
		SideBarView {
			Text("123")
		}
	}
}
