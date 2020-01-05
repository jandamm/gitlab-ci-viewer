//
//  ServerView.swift
//  GitlabCiWatcher
//
//  Created by Jan Dammshäuser on 05.01.20.
//  Copyright © 2020 Jan Dammshäuser. All rights reserved.
//

import SwiftUI

struct Server: Identifiable {
    var id: URL { url }

    let name: String
    let url: URL
}

typealias ProjectListView = Text

struct ServerView: View {
    @State var servers: [Server] = [
        Server(name: "Seven Principles", url: URL(string: "https://gitlab.7p-group.com")!),
        Server(name: "Gitlab", url: URL(string: "https://gitlab.com")!)
    ]
    @State var showAddServerView: Bool = false

    var body: some View {
        NavigationView {
            List(servers) { server in
                NavigationLink(destination: ProjectListView(server.name)) {
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
              .sheet(isPresented: $showAddServerView, onDismiss: { self.showAddServerView = false}, content: { LoginView() })
        }
    }
}

struct ServerView_Previews: PreviewProvider {
    static var previews: some View {
        let view = ServerView()
        view.servers = [
            Server(name: "Seven Principles", url: URL(string: "https://gitlab.7p-group.com")!),
            Server(name: "Gitlab", url: URL(string: "https://gitlab.com")!)
        ]
        return  view
    }
}
