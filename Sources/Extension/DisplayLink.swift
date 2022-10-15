//
//  DisplayLink.swift
//  Splatoon3 Gear Manager
//
//  Created by 庄黛淳华 on 2022/10/12.
//

import Foundation
import QuartzCore

public class Displaylink {

#if DEBUG
	let timer: DispatchSourceTimer? = {
		if SwiftUIConstants.isPreview {
			return nil
		} else {
			return DispatchSource.makeTimerSource()
		}
	}()
#else
	let timer: DispatchSourceTimer? = DispatchSource.makeTimerSource()
#endif


	public init(timeInterval: DispatchTimeInterval) {
		timer?.schedule(deadline: .now(), repeating: timeInterval, leeway: .microseconds(500))
	}

	public func setAction(_ action: @escaping () -> Void) {
		timer?.setEventHandler(handler: DispatchWorkItem(block: action))
		timer?.resume()
	}

	deinit {
		timer?.cancel()
	}
}
