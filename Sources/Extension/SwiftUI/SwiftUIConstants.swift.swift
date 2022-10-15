//
//  SwiftUIConstants.swift
//  
//
//  Created by 庄黛淳华 on 2022/10/12.
//

import Foundation

public enum SwiftUIConstants {
	public static let isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
