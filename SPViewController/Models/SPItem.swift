//
//  SPItem.swift
//  AppSearchablePicker
//
//  Created by Pawan on 23/07/19.
//  Copyright © 2019 VDB. All rights reserved.
//

import Foundation

/// Searchable Item model
public class SPItem {
	
	/// Variables
	public var title: String
	public var detail: String?
	public var image: String?
	
	// MARK: Designated initialiser
	public init(title: String, detail: String? = nil, image: String? = nil) {
		self.title = title
		self.detail = detail
		self.image = image
	}
	
}
