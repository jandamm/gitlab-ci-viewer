//
// Created by Jan Dammshäuser on 05.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation

var Current: Env = Env()

private let serverKey = "udServer"
struct Env {
	var getServers: () -> [Server] = { (try? UserDefaults.standard.get([Server].self, forKey: serverKey)) ?? [] }
	var saveServers: ([Server]) -> Void = { try? UserDefaults.standard.set($0, forKey: serverKey) }
}

extension Env {
	@discardableResult
	func appendingServer(_ server: Server) -> [Server] {
		var servers = getServers()
		servers.append(server)
		saveServers(servers)
		return servers
	}
}

extension Env {
	static let mock: Env = .init(
		getServers: { Server.mock },
		saveServers: { _ in }
	)
}