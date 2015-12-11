//
//  FlickCollectionViewCell.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 24/11/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

// manage individual cells in the (initial) Collection view 
class FlickCell: UICollectionViewCell {
    @IBOutlet
    weak var flickImage: UIImageView!
    
    override func awakeFromNib() {
        flickImage.layer.cornerRadius = 3
        flickImage.clipsToBounds = true
    
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(0, 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.8       
    }
}
