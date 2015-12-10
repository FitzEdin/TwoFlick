//
//  CollectionViewController.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 24/11/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

// manage the (initial) collection view
class CollectionViewController: UICollectionViewController {
    
    var flickList = [FlickItem]()
    var getFotos = GetPhotos(apiKey: "018c00fa2d9b15eea951e9a9efa8137d")
    var page = 1
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    @IBOutlet weak var lgActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFotos.collectionViewCtrl = self
        lgActivityIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
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
        print(indexPath.row)
        print(flickList.count)
        let item = flickList[indexPath.row]
        cell.flickImage.image = item.smImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let num = flickList.count - indexPath.item
        
        if num == 30 {
            //load the next page of images
            getFotos.grabRecentPhotos(page)
            page++
        }
    }
    
    @IBAction func refreshFlicks(sender: AnyObject) {
        lgActivityIndicator.startAnimating()

        flickList.removeAll()
        //resets the collection view and scroll position
        self.collectionView?.reloadData()
        
        self.collectionView?.addSubview(activityIndicator)
        
        getFotos.grabRecentPhotos(1)
    }
    
}

extension CollectionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        flickList.removeAll()
        
        //resets the collection view and scroll position
        self.collectionView?.reloadData()
        // spin that activity indicator until the search returns
 /*       textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds      */
        lgActivityIndicator.startAnimating()

        
        if let tx = textField.text{
            let newTx = tx.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())
            if(newTx == ""){
                //pop up indicator?
            }else{
                getFotos.searchFor(newTx!)
            }
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}
