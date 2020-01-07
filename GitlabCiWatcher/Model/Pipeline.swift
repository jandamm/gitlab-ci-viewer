//
// Created by Jan Dammshäuser on 01.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct Pipeline: Identifiable, Decodable {
	typealias Id = Tagged<Pipeline, Int>
	let id: Id
	let ref: String
	let sha: String
	let createdAt: Date
	let status: Job.Status
}
