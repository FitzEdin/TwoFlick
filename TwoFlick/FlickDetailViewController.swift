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
        let image = item.smImage
        
        let sheet = UIActivityViewController(activityItems: [message, image], applicationActivities: nil)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    @IBAction func flickInfo(sender: UIBarButtonItem) {
        let me = UIAlertController(title: "Info", message: "All information about the picture", preferredStyle: .ActionSheet)
        me.addAction(
            UIAlertAction(
                title: "Close",
                style: .Destructive,
                handler:nil )
        )
        self.presentViewController(me, animated: true, completion: nil)
    }
    
    @IBAction func flickComments(sender: UIBarButtonItem) {
        let me = UIAlertController(title: "Comments", message: "These are your comments", preferredStyle: UIAlertControllerStyle.Alert)
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
        self.flickImageVw.image = item.smImage  
        
        loadLgImg()
        getUser()
    }
    
    override func viewDidLoad() {
        // Swipe left gesture
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "loadImage")
        swipeRight.direction = .Right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    //
    func loadImage(){
        print("Swipe to the right detected")
    }
    
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
    
    private func gotLgImage(data: NSData?){
        guard data != nil else {
            print("no data")
            return
        }
        
        //get the larger image
        let image = UIImage(data: data!)
        
        dispatch_async(
            dispatch_get_main_queue(),
            {   self.flickImageVw.image = image }
        )
    }
    
    
    private func getUser(){
        let apiKey = "018c00fa2d9b15eea951e9a9efa8137d"
        let url = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.people.getInfo&api_key=\(apiKey)&user_id=\(item.owner)&format=json&nojsoncallback=1")!
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
    
    private func gotOwner(data: NSData?){
        var name: String!
        guard data != nil else {
            print("no data")
            return
        }
        
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
            let photos = jsonData["person"] as! NSDictionary
            let photo = photos["username"] as! NSDictionary
            name = photo["_content"] as! String
        } catch let error {
            print("error \(error)")
        }
        
        dispatch_async(
            dispatch_get_main_queue(),
            {   //self.navigationItem.title = name
                self.flickOwnerLabel.text = /*"See more by \n*/"By \(name)"
            }
        )
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
