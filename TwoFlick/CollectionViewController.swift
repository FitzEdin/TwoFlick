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
    let apiKey = "018c00fa2d9b15eea951e9a9efa8137d"
    
    // segue identifiers
    let noNetworkSegue = "noNetworkSegue"
    let flickDetailSegue = "flickDetailSegue"
    
    var refreshControl : UIRefreshControl!
    var flickList = [FlickItem]()
    var getFotos : GetPhotos!
    var page = 1
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        refreshFlicks()
    }
    
    @IBOutlet weak var lgActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if network.isConnected() {
            getFotos = GetPhotos(apiKey: apiKey)
            getFotos.collectionViewCtrl = self
            
            //animate the activity indicator
            lgActivityIndicator.startAnimating()
        } else {
            performSegueWithIdentifier(noNetworkSegue, sender: self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.toolbarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == flickDetailSegue && networkIsUp(){
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
    
    
    // MARK: Refresh Actions
    // handles the refresh button click
    private func refreshFlicks() {
        if networkIsUp() {
            lgActivityIndicator.startAnimating()// spin the activity indicator
            refreshSelf()
            getFotos.grabRecentPhotos(1)
        }
    }
    
    //also used when searching
    private func refreshSelf(){
        flickList.removeAll()               // empty the collection view
        self.collectionView?.reloadData()   // and reset the scroll position
    }
    
    
    // MARK: Network Connection
    // check for network connectivity
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


// handle input from search bar
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
