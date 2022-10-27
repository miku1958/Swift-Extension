//
//  AlertButton.swift
//  
//
//  Created by 庄黛淳华 on 2022/10/26.
//

import SwiftUI

public struct AlertButton<Label, Action>: View where Label: View, Action: View {
	let label: () -> Label
	let titleKey: LocalizedStringKey
	let actions: () -> Action

	@State var isPresented: Bool = false

	public init(@ViewBuilder label: @escaping () -> Label, titleKey: LocalizedStringKey, @ViewBuilder actions: @escaping () -> Action) {
		self.label = label
		self.titleKey = titleKey
		self.actions = actions
	}

	public var body: some View {
		Button {
			isPresented = true
		} label: {
			label()
		}
		.alert(titleKey, isPresented: $isPresented, actions: actions)
    }
}

struct AlertButton_Previews: PreviewProvider {
    static var previews: some View {
		AlertButton(label: {

		}, titleKey: "", actions: {

		})
    }
}
