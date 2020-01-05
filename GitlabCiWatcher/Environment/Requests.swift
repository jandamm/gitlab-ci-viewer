//
// Created by Jan Dammshäuser on 05.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Combine

private let decoder = JSONDecoder()
private let encoder = JSONEncoder()

private enum Path {
	case projects

	fileprivate func url(for server: Server) -> URL {
		let url = server.url.appendingPathComponent("api/v4")
		switch self {
		case .projects:
			return url.appendingPathComponent("users/\(server.username)/projects?archived=false")
		}
	}
}

enum Requests {
	private static func request(server: Server, path: Path) -> URLSession.DataTaskPublisher {
		var request = URLRequest(url: path.url(for: server))
		request.addValue("Bearer \(server.accessToken))", forHTTPHeaderField: "Authorization")
		return URLSession.shared.dataTaskPublisher(for: request)
	}

	static func projects(on server: Server) -> AnyPublisher<[Project], URLError> {
		request(server: server, path: .projects)
			.compactMap { data, response in
				try? decoder.decode([Project].self, from: data)
			}
			.eraseToAnyPublisher()
	}
}