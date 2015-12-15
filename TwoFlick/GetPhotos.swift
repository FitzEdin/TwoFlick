//
//  GetPhotos.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 29/11/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

class GetPhotos{
    
    var collectionViewCtrl: CollectionViewController?
    private var images = [FlickItem]()
    private var apiKey : String
    private var page : Int!
    private var count : Int!
    
    // get smaller image for flickItem
    private func gotImage(data: NSData?, title: String, baseURL: String, farm: Int, server: String , secret: String, id: String, owner: String){
        guard data != nil else {
            print("no data")
            return
        }
        
        // extract image and create flickItem
        let image = UIImage(data: data!)
        if image != nil {
            let item = FlickItem(title: title, smImg: image!, baseURL: baseURL, farm: farm, server: server, secret: secret, id: id, owner: owner)
            images.append(item)
        }
        
        if((images.count) % 50 == 0){
            dispatch_async(dispatch_get_main_queue(),
                { () -> Void in
                    self.collectionViewCtrl?.lgActivityIndicator.stopAnimating()
                    self.collectionViewCtrl?.flickList.appendContentsOf(self.images)
                    self.collectionViewCtrl?.collectionView?.reloadData()
                    self.images.removeAll()
                }
            )
        }
    }
    
    // parse that JSON data
    private func handleData(data : NSData?){
        guard data != nil else {
            print("no data")
            return
        }
        
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
            let photos = jsonData["photos"]! as! NSDictionary
            let photo = photos["photo"]! as! NSArray
            
            for var first in photo {
                // grab parameters for URL
                let farm = first["farm"]! as! Int
                let server = first["server"]! as! String
                let secret = first["secret"]! as! String
                let id = first["id"]! as! String
                let title = first["title"]! as! String
                let owner = first["owner"]! as! String
                print(title)
                
                // form URL with appropriate parameters
                let size = "t.jpg"
                let baseURL = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_"
                let imageURL = baseURL + size
                
                // request data
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithURL(
                    NSURL(string: imageURL)!,
                    completionHandler: {
                        data,
                        response,
                        error in self.gotImage(data, title: title, baseURL: baseURL, farm: farm, server: server, secret: secret, id: id, owner: owner)
                    }
                )
                
                task.resume()
            }
        } catch let error {
            print("error \(error)")
        }
    }
    
    // perform a search with a particular term
    internal func searchFor(searchTerm: String){
        // generate a url using the search term
        let str = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(searchTerm)&format=json&nojsoncallback=1"
        let url = NSURL(string: str)!
        
        // perform the search
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
    
    // grab the most recent set of pics..
    internal func grabRecentPhotos(page : Int) {
        // generate a url
        (self.page!)++
        let url = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(apiKey)&per_page=\(count)&page=\(self.page)&format=json&nojsoncallback=1")!
        
        // grab the data from url
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
    
    // set initial values and get the first set of photos
    init(apiKey: String){
        self.apiKey = apiKey
        self.page = 0
        self.count = 50
        grabRecentPhotos(self.page)
    }
}
