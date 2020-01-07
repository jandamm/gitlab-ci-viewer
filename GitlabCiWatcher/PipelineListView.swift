//
// Created by Jan Dammshäuser on 07.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation
import SwiftUI


private let dateFormatter: DateFormatter = {
	let dateFormatter = DateFormatter()
	dateFormatter.dateStyle = .short
	dateFormatter.timeStyle = .short
	return dateFormatter
}()

struct PipelineListView: View {
	@ObservedObject var model: PipelineListModel

	var body: some View {
		List(model.pipelines) { pipeline in
			VStack {
				Text(dateFormatter.string(from: pipeline.createdAt))
				Text(pipeline.ref)
					.bold()
			}
		}
			.onAppear(perform: model.load)
			.navigationBarTitle(Text(model.project.name))
	}
}

struct PipelineListView_Preview: PreviewProvider {
	static var previews: some View {
		Current = .mock
		return PipelineListView(model: PipelineListModel(server: Current.getServers().first ?? .mock, project: .init(id: .init(rawValue: 1234), name: "Project")))
	}
}
