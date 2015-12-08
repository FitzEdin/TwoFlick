//
//  SearchPhotos.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 08/12/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit


struct FlickrSearchResults {
    let searchTerm : String
    let searchResults : [FlickItem] // <-- an array of FlickItems is needed in my class
}

class SearchPhotos {
    /*
    let processingQueue = NSOperationQueue()
    
    // search Flickr and place results in struct
    func searchFlickrForTerm(
        searchTerm: String,
        completion : (
            results: FlickrSearchResults?,
            error : NSError?) -> Void){
            
            //get an appropriate URL for the search term
            let searchURL = flickrSearchURLForSearchTerm(searchTerm)
            let searchRequest = NSURLRequest(URL: searchURL)
            
            NSURLConnection.sendAsynchronousRequest(searchRequest, queue: processingQueue) {
                response, data, error in
                
                //if we got back nothing, set results to nil
                if error != nil {
                    completion(results: nil,error: error)
                    return
                }
                
                //otherwise, let's pretend JSONError is an NSError
                var JSONError : NSError?
                
                //..then do some stuff, like..
                do{
                    //..populating a dictionary with our JSONified results
                    let resultsDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary
                    
                    //now check the status of what was returned..
                    switch (resultsDictionary!["stat"] as! String) {
                        //was it good?
                    case "ok":
                        print("Results processed OK")
                        //was it bad?
                    case "fail":
                        //blame the API
                        let APIError = NSError(
                            domain: "FlickrSearch",
                            code: 0,
                            userInfo: [NSLocalizedFailureReasonErrorKey:resultsDictionary!["message"]!])
                        //..and let the whole world know it was the API's fault
                        completion(results: nil, error: APIError)
                        return
                        //and in case we're not sure what happened
                    default:
                        //..blame the API anyway
                        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Uknown API response"])
                        completion(results: nil, error: APIError)
                        return
                    }
                    
                    //now that the checking is done, and we're all clear, do the real work..
                    let photosContainer = resultsDictionary!["photos"] as! NSDictionary
                    let photosReceived = photosContainer["photo"] as! [NSDictionary]
                    
                    let flickItems : [FlickItem] = photosReceived.map {
                        photoDictionary in
                        
                        let photoID = photoDictionary["id"] as? String ?? ""
                        let farm = photoDictionary["farm"] as? Int ?? 0
                        let server = photoDictionary["server"] as? String ?? ""
                        let secret = photoDictionary["secret"] as? String ?? ""
                        
                        let flickItem = FlickItem(photoID: photoID, farm: farm, server: server, secret: secret)
                        
                        let imageData = NSData(contentsOfURL: flickItem. rPhoto.flickrImageURL())
                        flickrPhoto.thumbnail = UIImage(data: imageData!)
                        
                        return flickrPhoto
                    }
                    
                    dispatch_async(
                        dispatch_get_main_queue(),
                        {
                            completion(
                                results:FlickrSearchResults(
                                    searchTerm: searchTerm,
                                    searchResults: flickrPhotos),
                                error: nil
                            )
                        }
                    )
                }catch let error {
                    print("error\(error)")
                }
                if JSONError != nil {
                    completion(results: nil, error: JSONError)
                    return
                }
            }
    }
    
    //append search term to a proper search URL
    private func flickrSearchURLForSearchTerm(searchTerm:String) -> NSURL {
        let escapedTerm = searchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"
        return NSURL(string: URLString)!
    }
*/
}