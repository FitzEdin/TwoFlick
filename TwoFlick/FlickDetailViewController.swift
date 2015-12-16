//
//  FlickDetailViewController.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 01/12/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

class FlickDetailViewController: UIViewController {
    
    let size = "z.jpg"
    let apiKey = "018c00fa2d9b15eea951e9a9efa8137d"
    var noLocation = true
    var item : FlickItem!
    
    
    @IBOutlet weak var flickImageVw: UIImageView!
    @IBOutlet weak var flickLabel: UILabel!
    @IBOutlet weak var flickOwnerLabel: UILabel!
    @IBAction func flickShare(sender: AnyObject) {
        let message = item.title
        let image = item.lgImage
        
        let sheet = UIActivityViewController(activityItems: [message, image], applicationActivities: nil)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    @IBAction func flickInfo(sender: UIBarButtonItem) {
        let me = UIAlertController(title: "\(item.title)", message: "By \(item.ownerName) \n \(item.views) views \n \(item.commentCount) comments", preferredStyle: .Alert)
        me.addAction(
            UIAlertAction(
                title: "Close",
                style: .Default,
                handler:nil )
        )
        self.presentViewController(me, animated: true, completion: nil)
    }
    
    @IBAction func flickComments(sender: UIBarButtonItem) {
        let me = UIAlertController(title: "Tags", message: "Lat: \(item.lat) Lon: \(item.lon)", preferredStyle: .Alert)
        me.addAction(
            UIAlertAction(
                title: "Close",
                style: .Default,
                handler:nil )
        )
        self.presentViewController(me, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.flickLabel.text = item.title
        
        // add rounding to the image's corners
        flickImageVw.layer.cornerRadius = 3
        flickImageVw.clipsToBounds = true
        flickImageVw.alpha = 0.2
        flickImageVw.image = item.smImage
        
        loadLgImg()
        getInfo()
        getLoc()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Swipe left gesture
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "loadMap")
        swipeLeft.direction = .Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    //
    func loadMap(){
        if noLocation {
            let me = UIAlertController(title: "Location Unknown", message: "No location information is available for this photo", preferredStyle: .ActionSheet )
            me.addAction(
                UIAlertAction(
                    title: "Close",
                    style: .Default,
                    handler:nil )
            )
            self.presentViewController(me, animated: true, completion: nil)
        }else{
            self.performSegueWithIdentifier("mapSegue", sender: self)
        }
    }
    
    
    
    // MARK: Network Querying
    
    /*Load a larger image*/
    //function for loading the large image
    private func loadLgImg(){
        
        let imageURL = item.baseURL + size
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(
            NSURL(string: imageURL)!,
            completionHandler: {
                data,
                response,
                error in self.gotLgImage(data)
            }
        )
        task.resume()
    }
    
    // unwrap the network data for the larger image
    private func gotLgImage(data: NSData?){
        guard data != nil else {
            print("no data")
            return
        }
        
        //get the larger image
        if let image = UIImage(data: data!) {
            dispatch_async(
                dispatch_get_main_queue(),
                {   UIView.animateWithDuration(
                        1.6,
                        animations: {
                            self.item.lgImage = image
                            self.flickImageVw.image = image
                            self.flickImageVw.alpha = 1.0
                        }
                    )
                }
            )
        }
    }
    
    
    
    /* Load additional info about the flick*/
    // query the network for further infor on the photo
    private func getInfo(){
        let url = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=\(apiKey)&photo_id=\(item.id)&format=json&nojsoncallback=1")!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(
            url,
            completionHandler: {
                data,
                response,
                error in self.gotInfo(data!)
            }
        )
        
        task.resume()
    }
    
    //unwrap the network data for further info on the photo
    private func gotInfo(data: NSData?){
        
        guard data != nil else {
            print("no data")
            return
        }
        
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
            let photo = jsonData["photo"] as! NSDictionary
            
            // get .owner.username
            let owner = photo["owner"] as! NSDictionary
            item.ownerName = owner["username"] as! String
            
            //get .description._content
            var me = photo["description"] as! NSDictionary
            item.flkDescription = me["_content"] as! String
            //get .comments._content
            me = photo["comments"] as! NSDictionary
            item.commentCount = me["_content"] as! String
            //get .dates.taken
            me = photo["dates"] as! NSDictionary
            item.dateTaken = me["taken"] as! String
            //get .views
            item.views = photo["views"] as! String
            
        } catch let error {
            print("error \(error)")
        }
        
        dispatch_async(
            dispatch_get_main_queue(),
            {   self.flickOwnerLabel.text = "By \(self.item.ownerName)"
            }
        )
    }
    
    
    
    /* Load additional info about the flick*/
    // query the network for further infor on the photo
    private func getLoc(){
        print(item.id)
        let url = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=\(apiKey)&photo_id=\(item.id)&format=json&nojsoncallback=1")!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(
            url,
            completionHandler: {
                data,
                response,
                error in self.gotLoc(data!)
            }
        )
        
        task.resume()
    }
    
    //unwrap the network data for further info on the photo
    private func gotLoc(data: NSData?){
        guard data != nil else {
            print("no data")
            return
        }
        
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
            
            let stat = jsonData["stat"] as! String
            print(stat)
            if stat == "fail" {
                noLocation = true
                return
            }else{
                noLocation = false
                let photo = jsonData["photo"] as! NSDictionary
                
                // get .location.latitude and .longitude
                let location = photo["location"] as! NSDictionary
                item.lat = location["latitude"] as! String
                item.lon = location["longitude"] as! String
            }
        } catch let error {
            print("error \(error)")
        }
        
        dispatch_async(
            dispatch_get_main_queue(),
            {   self.flickOwnerLabel.text = "By \(self.item.ownerName)"
            }
        )
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! FlickMapViewController
        dest.lat = Double(item.lat)!
        dest.lon = Double(item.lon)!
    }
}
