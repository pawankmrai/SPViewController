//
//  SPTextTableViewCell.swift
//  AppSearchablePicker
//
//  Created by Pawan on 25/07/19.
//  Copyright © 2019 VDB. All rights reserved.
//

import UIKit

class SPTextTableViewCell: UITableViewCell {
	
	static var identifier: String = "SPTextTableViewCell"
	
	@IBOutlet weak var locationName: UILabel!
	@IBOutlet weak var checkMarkImageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	override var isSelected: Bool {
		didSet {
			checkMarkImageView.image = self.isSelected ? UIImage(named: "done") : nil
		}
	}
}

