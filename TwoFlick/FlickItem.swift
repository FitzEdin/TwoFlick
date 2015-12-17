//
//  FlickItem.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 24/11/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

// the data structure for each item
class FlickItem {
    // initial info
    var baseURL: String
    var farm: Int
    var server: String
    var secret: String
    var id: String
    var title: String
    var owner: String
    var smImage: UIImage
    
    // get this in detail controller
    var lgImage: UIImage!
    
    var ownerName: String!
    var views: String!
    var dateTaken: String!
    var commentCount: String!
    var flkDescription: String!
    
    var lat: String!
    var lon: String!
    
    
    init(title: String, smImg: UIImage, baseURL: String, farm: Int, server: String , secret: String, id: String, owner: String) {
        self.title = title
        self.smImage = smImg
        self.baseURL = baseURL
        
        self.farm = farm
        self.server = server
        self.secret = secret
        self.id = id
        self.owner = owner
    }
}
