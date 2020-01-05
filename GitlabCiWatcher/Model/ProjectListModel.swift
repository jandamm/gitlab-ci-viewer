//
// Created by Jan Dammshäuser on 05.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Combine

class ProjectListModel: ObservableObject {
	@Published private(set) var projects: [Project] = []
	let server: Server
	private var observer: AnyCancellable?

	init(server: Server) {
		self.server = server
	}

	deinit {
		observer?.cancel()
	}

	func load() {
		guard observer == nil else { return }

		observer = Current.getProjects(server)
			.sink(
				receiveCompletion: { [weak self] c in
					switch c {
					case .finished:
						self?.observer = nil
					case let .failure(error):
						print(error)  // ignore errors for now
					}
				},
				receiveValue: { [weak self] value in
					DispatchQueue.main.async {
						self?.projects = value
					}
				}
		)
	}
}
