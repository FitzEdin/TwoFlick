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
    var lgImg : UIImage!
    var url : String!
    let size = "z.jpg"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = item.title
        self.url = item.baseURL
        self.flickLabel.text = item.title
        self.flickImageVw.image = item.smImage
        
        loadLgImg()
        
        // add rounding to the image's corners
        /*flickImageVw.layer.cornerRadius = 20
        flickImageVw.clipsToBounds = true*/
    }
    
    //function for loading the large image
    func loadLgImg(){
        
        let imageURL = url + size
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
    
    
    func gotLgImage(data: NSData?){
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
