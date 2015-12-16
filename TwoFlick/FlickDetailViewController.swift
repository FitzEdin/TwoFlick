//
//  FlickDetailViewController.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 01/12/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

class FlickDetailViewController: UIViewController {
    
    var lgImg : UIImage!
    let size = "z.jpg"
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
        let me = UIAlertController(title: "\(item.title)", message: "By \(item.ownerName) \n \(item.views) views \n \(item.commentCount) comments \n adding \n random \n lines \n to this \n thing", preferredStyle: .Alert)
        me.addAction(
            UIAlertAction(
                title: "Close",
                style: .Default,
                handler:nil )
        )
        self.presentViewController(me, animated: true, completion: nil)
    }
    
    @IBAction func flickComments(sender: UIBarButtonItem) {
        let me = UIAlertController(title: "Comments", message: "These are your comments", preferredStyle: .Alert)
        me.addAction(
            UIAlertAction(
                title: "Close",
                style: .Destructive,
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
        getUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Swipe left gesture
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "loadMa")
        swipeLeft.direction = .Left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        // Swipe down gesture
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "loadMap")
        swipeDown.direction = .Down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    //
    func loadMap(){
        self.performSegueWithIdentifier("mapSegue", sender: self)
    }
    
    //
    func loadMa(){
        
        self.performSegueWithIdentifier("downSegue", sender: self)
    }
    
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
    private func getUser(){
        let apiKey = "018c00fa2d9b15eea951e9a9efa8137d"
        let url = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=\(apiKey)&photo_id=\(item.id)&format=json&nojsoncallback=1")!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(
            url,
            completionHandler: {
                data,
                response,
                error in self.gotOwner(data!)
            }
        )
        
        task.resume()
    }
    
    //unwrap the network data for further info on the photo
    private func gotOwner(data: NSData?){
        
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
            {   //self.navigationItem.title = name
                self.flickOwnerLabel.text = /*"See more by \n*/"By \(self.item.ownerName)"
                //self.flickDetailOwnerLabel.text = "\(self.name)"
            }
        )
    }

    
/*
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
*/
}
