//
//  CommentCell.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 17/12/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var commentDetail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
