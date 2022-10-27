//
//  Image+Extension.swift
//  
//
//  Created by 庄黛淳华 on 2022/10/15.
//

import Foundation
import SFSafeSymbols
import SwiftUI

extension Image {
	public static let placeholder = Image(systemSymbol: .photo)

	public init(resourceName: String, in bundle: Bundle = .main) {
		guard let path = bundle.path(forResource: resourceName, ofType: nil) else {
#if DEBUG
			fatalError("file \(resourceName) is missing")
#endif
			self = .placeholder
			return
		}
		self = Self(contentsOfFile: path)
	}

	public init(contentsOfFile path: String) {
		#if os(macOS)
		self = NSImage(contentsOfFile: path).map(Image.init(nsImage:)) ?? .placeholder
		#elseif os(iOS)
		self = UIImage(contentsOfFile: path).map(Image.init(uiImage:)) ?? .placeholder
		#else
		self = .placeholder
		#endif
	}
}
