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

private let decoder: JSONDecoder = {
	let decoder = JSONDecoder()
	let formatter = DateFormatter()
	formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
	decoder.dateDecodingStrategy = .formatted(formatter)
	decoder.keyDecodingStrategy = .convertFromSnakeCase
	return decoder
}()

private enum Path {
	case projects
	case userProjects
	case pipelines(Project)
	case jobs(Project, Pipeline)

	private static let archived = URLQueryItem(name: "archived", value: "false")
	fileprivate func url(for server: Server) -> URL {
		let url = server.url.appendingPathComponent("api/v4")
		var components: URLComponents?
		switch self {
		case .projects:
			components = URLComponents(
				url: url.appendingPathComponent("projects")
			)
			components?.appendQueryItem(Path.archived)
		case .userProjects:
			components = URLComponents(
				url: url.appendingPathComponent("users/\(server.username)/projects")
			)
			components?.appendQueryItem(Path.archived)
		case let .pipelines(project):
			components = URLComponents(
				url: url.appendingPathComponent("projects/\(project.id.rawValue)/pipelines")
			)
		case let .jobs(project, pipeline):
			components = URLComponents(
				// https://gitlab.com/api/v4/projects/14665861/pipelines/89023438/jobs?access_token=F9gqa7P2LLbYJrR7xR5v
				url: url.appendingPathComponent("projects/\(project.id.rawValue)/pipelines/\(pipeline.id.rawValue)/jobs")
			)
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

	static func projects(server: Server) -> AnyPublisher<[Project], URLError> {
		let decode: (Data, URLResponse) -> [Project]? = { data, response in
			try? decoder.decode([Project].self, from: data)
		}
		let userProjects = request(server: server, path: .userProjects)
			.compactMap(decode)
		let projects = request(server: server, path: .projects)
			.compactMap(decode)

		return	projects.combineLatest(userProjects)
			.map(+)
			.eraseToAnyPublisher()
	}

	static func pipelines(server: Server, project: Project) -> AnyPublisher<[Pipeline], URLError> {
		request(server: server, path: .pipelines(project))
			.compactMap { data, response in
				try? decoder.decode([Pipeline].self, from: data)
			}
			.eraseToAnyPublisher()
	}

	static func jobs(server: Server, project: Project, pipeline: Pipeline) -> AnyPublisher<[Job], URLError> {
		request(server: server, path: .jobs(project, pipeline))
			.compactMap { data, response in
				try? decoder.decode([Job].self, from: data)
			}
			.eraseToAnyPublisher()
	}
}