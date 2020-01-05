//
// Created by Jan Dammshäuser on 05.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct Server: Identifiable, Codable {
	var id: URL { url }

	let name: String
	let url: URL
	let username: String
	let accessToken: String
}

extension Partial where Value == Server {
	var name: String {
		get { self[\.name, default: ""] }
		set { self[\.name] = newValue }
	}
	var rawUrl: String {
		get { self[\.url.absoluteString, default: ""] }
		set { self[\.url.absoluteString] = newValue }
	}
	var username: String {
		get { self[\.username, default: ""] }
		set { self[\.username] = newValue }
	}
	var accessToken: String {
		get { self[\.accessToken, default: ""] }
		set { self[\.accessToken] = newValue }
	}

	func validated() -> Validated<Server, PartialKeyPath<Server>> {
		let errors = [\Server.name, \.username, \.accessToken]
			.compactMap { kp in
				self[kp, default: ""].isEmpty
					? kp
					: nil
		}

		switch (URL(string: rawUrl), errors.isEmpty) {
		case let (url?, true):
			return .valid(
				Server(name: name, url: url, username: username, accessToken: accessToken)
			)
		case (nil, _):
			var failures = errors.map { $0 as PartialKeyPath }
			failures.append(\Server.url)
			return .invalid(failures)
		case (.some, false):
			return .invalid(errors)
		}


	}
}
extension Server {
	static let mock = Server(name: "Gitlab", url: URL(string: "https://gitlab.com")!, username: "jandamm", accessToken: "brst")

	static let mocks = [
		mock,
		Server(name: "Seven Principles", url: URL(string: "https://gitlab.7p-group.com")!, username: "jandamm", accessToken: "arst"),
	]
}
