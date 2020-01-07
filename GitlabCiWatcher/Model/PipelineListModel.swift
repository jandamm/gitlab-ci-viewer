//
// Created by Jan Dammshäuser on 07.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Combine

class PipelineListModel: ObservableObject {
	@Published private(set) var pipelines: [Pipeline] = []
	@Published private(set) var jobs: [Pipeline.Id: [Job]] = [:]
	let server: Server
	let project: Project
	private var pipelineObserver: AnyCancellable?
	private var jobObservers: Set<AnyCancellable> = []

	init(server: Server, project: Project) {
		self.server = server
		self.project = project
	}

	deinit {
		pipelineObserver?.cancel()
		jobObservers.forEach { $0.cancel() }
	}

	func load() {
		guard pipelineObserver == nil else { return }

		pipelineObserver = Current.getPipelines(server, project)
			.sink(
				receiveCompletion: { [weak self] c in
					switch c {
					case .finished:
						self?.pipelineObserver = nil
					case let .failure(error):
						print(error)  // ignore errors for now
					}
				},
				receiveValue: { [weak self] value in
					DispatchQueue.main.async {
						self?.pipelines = value
						self?.loadJobs(for: value)
					}
				}
			)
	}

	private func loadJobs(for pipelines: [Pipeline]) {
		pipelines.forEach { pipeline in
			jobObservers.insert(
				Current.getJobs(server, project, pipeline)
				.sink(
					receiveCompletion: { _ in  }, // ignore errors for now
					receiveValue: { [weak self] value in
						DispatchQueue.main.async {
							self?.jobs[pipeline.id] = value
						}
					}
				)
			)
		}
	}
}