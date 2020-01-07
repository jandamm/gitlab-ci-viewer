//
// Created by Jan Dammshäuser on 07.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation
import SwiftUI

struct JobsView: View {
	// TODO: Remove full model
	@ObservedObject var model: PipelineListModel
	@State var pipeline: Pipeline.Id
	var body: some View {
		ForEach(model.jobs[pipeline] ?? []) { job in
			Text(job.statusImage)
		}
	}
}
