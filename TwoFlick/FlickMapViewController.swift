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
    
    var lat = 17.353
    var lon = -62.735

    @IBOutlet weak var flickMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(location, span)
        
        flickMapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.toolbarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
