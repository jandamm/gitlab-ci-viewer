//
// Created by Jan Dammshäuser on 07.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Combine

class PipelineListModel: ObservableObject {
	@Published private(set) var pipelines: [Pipeline] = []
	@Published private(set) var jobs: [Pipeline.Id: Job] = [:]
	let server: Server
	let project: Project
	private var observer: AnyCancellable?

	init(server: Server, project: Project) {
		self.server = server
		self.project = project
	}

	deinit {
		observer?.cancel()
	}

	func load() {
		guard observer == nil else { return }

		observer = Current.getPipelines(server, project)
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
						self?.pipelines = value
					}
				}
			)
	}
}