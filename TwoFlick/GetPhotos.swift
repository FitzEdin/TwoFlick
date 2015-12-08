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
    let apiKey = "018c00fa2d9b15eea951e9a9efa8137d"
    
    func gotImage(data: NSData?, title: String, baseURL: String, farm: Int, server: String , secret: String, id: String, owner: String, ownerName: String, views: Int){
        guard data != nil else {
            print("no data")
            return
        }
        
        let image = UIImage(data: data!)
        let item = FlickItem(title: title, smImg: image!, baseURL: baseURL, farm: farm, server: server , secret: secret, id: id, owner: owner, ownerName: ownerName, views: views)
        
        images.append(item)
        
        dispatch_async(dispatch_get_main_queue(),
            { () -> Void in
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
                let farm = first["farm"]! as! Int
                let server = first["server"]! as! String
                let secret = first["secret"]! as! String
                let id = first["id"]! as! String
                let title = first["title"]! as! String
                let owner = first["owner"]! as! String
                let ownerName = first["ownername"]! as! String
                //let views = first["views"]! as! Int
                let views = 0
                print(title)
                
                // form URL with appropriate parameters
                let size = "t.jpg"
                let baseURL = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_"
                let imageURL = baseURL + size
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithURL(
                    NSURL(string: imageURL)!,
                    completionHandler: {
                        data,
                        response,
                        error in self.gotImage(data, title: title, baseURL: baseURL, farm: farm, server: server, secret: secret, id: id, owner: owner, ownerName: ownerName, views: views)
                    }
                )
                task.resume()
            }
        } catch let error {
            print("error \(error)")
        }
    }
    
    init(mode: String){
        if(mode == "get"){
            get()
        }
    }
    
    func get(){
        let url = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(apiKey)&extras=owner_name%2C+views&format=json&nojsoncallback=1")!
        
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
