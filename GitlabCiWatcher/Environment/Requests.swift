//
// Created by Jan Dammshäuser on 05.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Combine

extension URLComponents {
	mutating func appendQueryItem(_ item: URLQueryItem) {
		if queryItems == nil { queryItems = [] }
		queryItems?.append(item)
	}

	init?(url: URL) {
		self.init(url: url, resolvingAgainstBaseURL: false)
	}
}

private let decoder = JSONDecoder()
private let encoder = JSONEncoder()

private enum Path {
	case projects

	fileprivate func url(for server: Server) -> URL {
		let url = server.url.appendingPathComponent("api/v4")
		var components: URLComponents?
		switch self {
		case .projects:
			components = URLComponents(
				url: url.appendingPathComponent("users/\(server.username)/projects")
			)
			components?.appendQueryItem(.init(name: "archived", value: "false"))
		}

		components?.appendQueryItem(.init(name: "access_token", value: server.accessToken))

		guard let output = components?.url else { fatalError() }

		return output
	}
}

enum Requests {
	private static func request(server: Server, path: Path) -> URLSession.DataTaskPublisher {
		URLSession.shared.dataTaskPublisher(
			for: URLRequest(url: path.url(for: server))
		)
	}

	static func projects(on server: Server) -> AnyPublisher<[Project], URLError> {
		request(server: server, path: .projects)
			.compactMap { data, response in
				try? decoder.decode([Project].self, from: data)
			}
			.eraseToAnyPublisher()
	}
}