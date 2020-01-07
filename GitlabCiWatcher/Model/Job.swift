//
// Created by Jan Dammshäuser on 01.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation
import UIKit

struct Job: Identifiable, Decodable {
	typealias Id = Tagged<Job, Int>
	let id: Id
	let name: String
	let status: Status
	let stage: String
	let allowFailure: Bool

	enum Status: String, Decodable {
		// https://docs.gitlab.com/ee/api/pipelines.html
		case running, pending, success, failed, canceled, skipped
	}

	var statusImage: String {
		switch status {
		case .failed where allowFailure:
			return "⚠️️"
		case .failed:
			return "⛔"
		case .pending:
			return "🅿️"
		case .success:
			return "✅"
		case .running:
			return "🕝"
		case .canceled:
			return "✖️"
		case .skipped:
			return "⏭"
		}
	}
}
