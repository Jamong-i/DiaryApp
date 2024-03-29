//
//  DiaryCell.swift
//  Diary
//
//  Created by Jamong on 2022/12/30.
//

import UIKit

class DiaryCell: UICollectionViewCell {
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!
	
	required init?(coder: NSCoder){
		super.init(coder: coder)
		self.contentView.layer.cornerRadius = 3.0
		self.contentView.layer.borderWidth = 1.0
		self.contentView.layer.borderColor = UIColor.black.cgColor
	}
}
