//
//  Objc_throws.swift
//
//
//  Created by 庄黛淳华 on 2019/11/9.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import ObjcExtension

extension NSException: Error { }

// swiftlint:disable identifier_name
@discardableResult
public func objc_try<T>(_ block: () throws -> T) throws -> T {
	var _error: Error?
	var _result: T!
	objc_catch({
		do {
			_result = try block()
		} catch {
			_error = error
		}
	}, { exc in
		_error = exc
	})
	if let _error = _error {
		throw _error
	} else {
		return _result
	}
}
