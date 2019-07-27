//
//  SPItem+App.swift
//  AppSearchablePicker
//
//  Created by Pawan on 23/07/19.
//  Copyright © 2019 VDB. All rights reserved.
//

import Foundation

extension SPItem: Equatable, Comparable {
	
	public static func < (lhs: SPItem, rhs: SPItem) -> Bool {
		return lhs.title < rhs.title
	}
	
	public static func == (lhs: SPItem, rhs: SPItem) -> Bool {
		return lhs.title == rhs.title
	}
	
}
