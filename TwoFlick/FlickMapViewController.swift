//
//  FlickMapViewController.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 15/12/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit
import MapKit

class FlickMapViewController: UIViewController {
    
    var lon = 1.063
    var lat = 51.295
    

    @IBOutlet weak var flickMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(location, span)
        
        flickMapView.setRegion(region, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
