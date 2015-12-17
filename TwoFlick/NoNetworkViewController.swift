//
//  NoNetworkViewController.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 17/12/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

class NoNetworkViewController: UIViewController {
    let phrases = ["Still not connected", "Try turning on your wifi..", "..or try turning on your data"]
    var network = Network()
    var i = 0
    
    @IBOutlet weak var refreshLabel: UILabel!
    
    @IBAction func retryButton(sender: UIButton) {
        refreshLabel.alpha = 0.0
        
        // if network is up, segue to collection view controller
        if network.isConnected() {
            self.performSegueWithIdentifier("refreshSegue", sender: self)
        } else { // else "refresh" the labels above
            self.refreshLabel.text = phrases[i%(phrases.count)]
            i++
            
            UIView.animateWithDuration(
                1.0,
                animations: {
                    self.refreshLabel.alpha = 1.0
                }
            )
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
