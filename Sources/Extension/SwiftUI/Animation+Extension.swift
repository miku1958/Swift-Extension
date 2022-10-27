//
//  Animation+Extension.swift
//  
//
//  Created by 庄黛淳华 on 2022/10/22.
//

import SwiftUI

extension Animation {
	public func repeatForever(active: Bool, autoreverses: Bool = true) -> Animation {
		if active {
			return repeatForever(autoreverses: autoreverses)
		} else {
			return self
		}
	}
}
