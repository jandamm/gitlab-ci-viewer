//
// Created by Jan Dammshäuser on 05.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation

// Not sure what pattern I'll use.
class ModelProvider: ObservableObject {
	@Published private(set) var servers: [Server] = Current.getServers()

	func addServer(_ server: Server) {
		servers = Current.appendingServer(server)
	}
}