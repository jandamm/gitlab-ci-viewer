//
// Created by Jan Dammshäuser on 01.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct Project: Decodable, Identifiable {
	let id: Tagged<Project, Int>
	let name: String
}
