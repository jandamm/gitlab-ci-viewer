//
// Created by Jan Dammshäuser on 05.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import SwiftUI

struct ProjectListView: View {
	@ObservedObject var model: ProjectListModel

	var body: some View {
		List(model.projects) { project in
			NavigationLink(destination: PipelineListView(model: .init(server: self.model.server, project: project))) {
				Text(project.name)
					.bold()
			}
		}
			.onAppear(perform: model.load)
			.navigationBarTitle(Text(model.server.name))
	}
}

struct ProjectListView_Preview: PreviewProvider {
	static var previews: some View {
		Current = .mock
		return ProjectListView(model: ProjectListModel(server: Current.getServers().first ?? .mock))
	}
}
