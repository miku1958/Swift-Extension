//
//  File.swift
//
//
//  Created by 庄黛淳华 on 2021/12/6.
//

import Foundation

extension FileManager {
	public enum Error: Swift.Error {
		case isNotDirectory
	}
	// Unlike fileExists, this method is  fileExists case-sensitive
	public func actualfileExists(atPath path: String) -> Bool {
		actualPathOf(caseInsensitivePath: path) == path
	}
	public func actualPathOf(caseInsensitivePath: String) -> String? {
		let file = fileSystemRepresentation(withPath: caseInsensitivePath)
		let fileDescriptor = open(file, O_RDONLY)
		defer {
			close(fileDescriptor)
		}
		if fileDescriptor != -1 {
			var buffer = [CChar](repeating: 0, count: Int(MAXPATHLEN))
			if fcntl(fileDescriptor, F_GETPATH, &buffer) != -1 {
				let realPath = String(cString: buffer)
				return realPath
			}
		}
		return nil
	}

	public func isDirectory(atPath stringPath: String) -> Bool {
		var isDirectory: ObjCBool = false
		return self.fileExists(atPath: stringPath, isDirectory: &isDirectory) && isDirectory.boolValue
	}

	public func isDirectory(at path: URL) -> Bool {
		isDirectory(atPath: path.standardizedFileURL.path)
	}

	public func isEmptyDirectory(at path: URL, recursiveSearch: Bool = false) throws -> Bool {
		guard isDirectory(at: path) else {
			throw Error.isNotDirectory
		}
		if try self.contentsOfDirectory(atPath: path.path).isEmpty {
			return true
		} else if recursiveSearch {
			do {
				for subPath in try self.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: []) {
					if subPath.lastPathComponent == ".DS_Store" {
						continue
					}
					if try !isEmptyDirectory(at: subPath, recursiveSearch: true) {
						return false
					}
				}
				return true
			} catch {
				return false
			}
		} else {
			return false
		}
	}
}
