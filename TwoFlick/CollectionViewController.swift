//
//  CollectionViewController.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 24/11/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

// manage the (initial) collection view
class CollectionViewController: UICollectionViewController {
    
    let reuseIdentifier = "Cell"
    let network = Network()
    var checkOnce = true
    var refreshControl : UIRefreshControl!
    internal var flickList = [FlickItem]()
    var getFotos : GetPhotos!
    var page = 1
    @IBOutlet weak var lgActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if network.isConnected() {
            
            print("not here")
            getFotos = GetPhotos(apiKey: "018c00fa2d9b15eea951e9a9efa8137d")
            
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: "refreshFlicks", forControlEvents: .ValueChanged)
            self.collectionView?.addSubview(refreshControl)
            getFotos.collectionViewCtrl = self
            
            //animate the activity indicator
            lgActivityIndicator.startAnimating()
        } else {
            
            print("here")
            performSegueWithIdentifier("noNetwork", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "flickDetailSegue" && networkIsUp(){
            let selection = self.collectionView?.indexPathsForSelectedItems()!
            let item = flickList[selection![0].row]
            let dest = segue.destinationViewController as! FlickDetailViewController
            dest.item = item
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    // the number of items in the list
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickList.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // get the last dequeued cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            reuseIdentifier,
            forIndexPath: indexPath)
            as! FlickCell
    
        // Configure the cell
        // get a handle on the next item to be shown
        let item = flickList[indexPath.row]
        cell.flickImage.image = item.smImage
        
        return cell
    }
    
    //implement infinite scrolling
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let num = flickList.count - indexPath.item
        
        if num == 10 && network.isConnected(){
            //load the next page of images
            getFotos.grabRecentPhotos(page)
            page++
        }
    }
    
    // handles the pull-down to refresh action
    func refreshFlicks() {
        if networkIsUp() {
            // the refresh control is spinning
            refreshSelf()
            getFotos.grabRecentPhotos(1)
            refreshControl.endRefreshing()
        }
    }
        
    
    private func refreshSelf(){
        flickList.removeAll()               // empty the collection view
        self.collectionView?.reloadData()   // and reset the scroll position
    }
    
    private func networkIsUp() -> Bool{
        if network.isConnected() {
            return true
        }else {
            //pop up an alert
            let me = UIAlertController(title: "Network Issues", message: "Can't connect to Flickr at the moment", preferredStyle: .Alert)
            me.addAction(
                UIAlertAction(
                    title: "Close",
                    style: .Default,
                    handler:nil )
            )
            self.presentViewController(me, animated: true, completion: nil)
            
            return false
        }
    }
    
}

extension CollectionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !networkIsUp() { return false    }
        if (textField.text == " ")||(textField.text == ""){
            return true
        }
        if let tx = textField.text {
            let newTx = tx.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())
            lgActivityIndicator.startAnimating()// spin the activity indicator
            refreshSelf()
            getFotos.searchFor(newTx!)
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}
