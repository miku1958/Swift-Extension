//
//  CGSize+Extension.swift
//  
//
//  Created by 庄黛淳华 on 2022/10/22.
//

import CoreFoundation

extension CGSize: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
	public init(floatLiteral value: FloatLiteralType) {
		self.init(width: value, height: value)
	}

	public init(integerLiteral value: IntegerLiteralType) {
		self.init(width: value, height: value)
	}
}
