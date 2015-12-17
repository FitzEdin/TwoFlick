//
//  Comment.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 17/12/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

// the data structure for each item
class Comment {
    var authorName: String
    var content: String
    
    init(authorName: String, content: String) {
        self.authorName = authorName
        self.content = content
    }
}
