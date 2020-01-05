//
//  ServerView.swift
//  GitlabCiWatcher
//
//  Created by Jan Dammshäuser on 05.01.20.
//  Copyright © 2020 Jan Dammshäuser. All rights reserved.
//

import SwiftUI
import Combine

struct ServerView: View {
	@ObservedObject var model: ServerListModel
	@State var showAddServerView: Bool = false

	var body: some View {
		NavigationView {
			List(model.servers) { server in
				NavigationLink(destination: ProjectListView(model: .init(server: server))) {
					VStack(alignment: .leading) {
						Text(server.name)
						  .bold()
						Spacer()
						Text(server.url.absoluteString)
						  .italic()
					}
				}
			}
			  .navigationBarTitle(Text("Servers"))
			  .navigationBarItems(trailing: Button(action: { self.showAddServerView = true }, label: { Text("Add") }))
			  .sheet(isPresented: $showAddServerView, onDismiss: { self.showAddServerView = false}, content: { ServerAddView(model: self.model) })
		}
	}
}

struct ServerView_Previews: PreviewProvider {
	static var previews: some View {
		Current = .mock
		return ServerView(model: ServerListModel())
	}
}
