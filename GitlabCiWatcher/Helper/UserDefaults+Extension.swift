//
// Created by Jan Dammshäuser on 05.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation

private let decoder = JSONDecoder()
private let encoder = JSONEncoder()

extension UserDefaults {
	func set<V: Codable>(_ value: V, forKey key: String) throws {
		try self.set(try encoder.encode(value), forKey: key)
	}

	func get<V: Codable>(_ type: V.Type, forKey key: String) throws -> V? {
		try self.data(forKey: key)
			.flatMap { data in
			try decoder.decode(type, from: data)
		}
	}
}
