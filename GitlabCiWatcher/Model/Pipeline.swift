//
// Created by Jan Dammshäuser on 01.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Tagged

struct Pipeline {
	let id: Tagged<Pipeline, Int>
	let ref: String
	let status: Job.Status
}