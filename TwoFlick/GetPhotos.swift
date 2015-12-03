//
//  GetPhotos.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 29/11/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

class GetPhotos{
    
    var images = [FlickItem]()
    var collectionViewCtrl: CollectionViewController?
    
    func gotImage(data: NSData?, title: String){
        guard data != nil else {
            print("no data")
            return
        }
        
        let image = UIImage(data: data!)
        let item = FlickItem(title: title, image: image!)
        
        images.append(item)
        
        dispatch_async(dispatch_get_main_queue(),
            { () -> Void in
                //let indexPath = NSIndexPath.init(forRow: (self.images.count)-1, inSection: 0)
                //self.collectionViewCtrl?.collectionView?.insertItemsAtIndexPaths([indexPath])
                self.collectionViewCtrl?.collectionView?.reloadData()
            }
        )
    }
    
    func handleData(data : NSData?){
        guard data != nil else {
            print("no data")
            return
        }
        
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
            let photos = jsonData["photos"] as! NSDictionary
            let photo = photos["photo"] as! NSArray
            
            
            //for i in 1...10{
                //let first = photo[i]
            for var first in photo {
                // grab parameters for URL
                let farm = first["farm"]!
                let server = first["server"]!
                let secret = first["secret"]!
                let id = first["id"]! as! String
                let title = first["title"]! as! String
                print(title)
                
                // form URL with appropriate parameters
                let imageURL = "https://farm\(farm!).staticflickr.com/\(server!)/\(id)_\(secret!)_z.jpg"
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithURL(
                    NSURL(string: imageURL)!,
                    completionHandler: {
                        data,
                        response,
                        error in self.gotImage(data, title: title)
                    }
                )
                task.resume()
            }
        } catch let error {
            print("error \(error)")
        }
    }
    
    init(){
        let apiKey = "018c00fa2d9b15eea951e9a9efa8137d"
        let url = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(apiKey)&per_page=100&format=json&nojsoncallback=1")!
    
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(
            url,
            completionHandler: {
                data,
                response,
                error in self.handleData(data!)
            }
        )
    
        task.resume()
    }
}
