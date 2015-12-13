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
    
    private let reuseIdentifier = "Cell"
    internal var flickList = [FlickItem]()
    var getFotos = GetPhotos(apiKey: "018c00fa2d9b15eea951e9a9efa8137d")
    private var page = 1
    @IBOutlet weak var lgActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFotos.collectionViewCtrl = self
        
        //animate the activity indicator
        lgActivityIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {        
        let selection = self.collectionView?.indexPathsForSelectedItems()!
        let item = flickList[selection![0].row]
        let dest = segue.destinationViewController as! FlickDetailViewController
        dest.item = item
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
        
        if num == 30 {
            //load the next page of images
            getFotos.grabRecentPhotos(page)
            page++
        }
    }
    
    // refresh the feed on button click
    @IBAction func refreshFlicks(sender: AnyObject) {
        refreshSelf()
        getFotos.grabRecentPhotos(1)
    }
    
    private func refreshSelf(){
        lgActivityIndicator.startAnimating()// spin the activity indicator
        flickList.removeAll()               // empty the collection view
        self.collectionView?.reloadData()   // and reset the scroll position
    }
    
}

extension CollectionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.text == " ")||(textField.text == ""){
            return true
        }
        if let tx = textField.text{
            let newTx = tx.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())
            refreshSelf()
            getFotos.searchFor(newTx!)
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}
