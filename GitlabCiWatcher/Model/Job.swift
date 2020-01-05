//
// Created by Jan Dammshäuser on 01.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Tagged

struct Job {
	let id: Tagged<Job, Int>
	let name: String
	let status: Status
	let stage: String

	enum Status: String {
		// https://docs.gitlab.com/ee/api/pipelines.html
		case running, pending, success, failed, canceled, skipped
	}
}
