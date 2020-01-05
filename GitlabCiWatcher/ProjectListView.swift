//
// Created by Jan Dammshäuser on 05.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import SwiftUI

struct ProjectListView: View {
	var model: ProjectListModel
	var body: some View {
		Text(model.server.name)
	}
}

struct ProjectListView_Preview: PreviewProvider {
	static var previews: some View {
		Current = .mock
		return ProjectListView(model: ProjectListModel(server: Current.getServers().first ?? .mock))
	}
}
