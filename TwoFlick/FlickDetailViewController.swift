//
//  FlickDetailViewController.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 01/12/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

class FlickDetailViewController: UIViewController {
    var item : FlickItem!
    @IBOutlet weak var flickImageVw: UIImageView!
    @IBOutlet weak var flickLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = item.title
        self.flickLabel.text = item.title
        flickImageVw.image = item.image
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
