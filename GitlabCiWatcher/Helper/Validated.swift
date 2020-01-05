//
// Created by Jan Dammshäuser on 05.01.20.
// Copyright (c) 2020 Jan Dammshäuser. All rights reserved.
//

import Foundation

enum Validated<Value, Failure> {
	case valid(Value)
	case invalid([Failure])
}
