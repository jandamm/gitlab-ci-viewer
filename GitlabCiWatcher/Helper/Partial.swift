//
// Created by Jan Dammshäuser on 05.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct Partial<Value> {
	private var store: [PartialKeyPath<Value>: Any] = [:]

	subscript <V>(_ kp: KeyPath<Value, V>) -> V? {
		get { store[kp] as? V }
		set { store[kp] = newValue }
	}

	subscript <V>(_ kp: KeyPath<Value, V>, default value: V) -> V {
		get { self[kp] ?? value }
		set { self[kp] = newValue }
	}
}
