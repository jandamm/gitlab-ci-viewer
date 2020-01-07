//
// Created by Jan Dammshäuser on 01.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct Job: Decodable {
	typealias Id = Tagged<Job, Int>
	let id: Id
	let name: String
	let status: Status
	let stage: String

	enum Status: String, Decodable {
		// https://docs.gitlab.com/ee/api/pipelines.html
		case running, pending, success, failed, canceled, skipped
	}
}
