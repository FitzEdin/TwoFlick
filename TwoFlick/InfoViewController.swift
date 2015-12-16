//
//  InfoViewController.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 15/12/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var item : FlickItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Swipe left gesture
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "loadMa")
        swipeLeft.direction = .Left
        self.view.addGestureRecognizer(swipeLeft)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //
    func loadMa(){
        self.performSegueWithIdentifier("upSegue", sender: self)
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
