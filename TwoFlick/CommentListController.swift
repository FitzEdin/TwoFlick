//
//  CommentListController.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 17/12/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import UIKit

class CommentListController: UITableViewController {
    
    var list = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.toolbarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentCell
        cell.commentTitle.text = list[indexPath.row].authorName
        cell.commentDetail.text = list[indexPath.row].content

        return cell
    }
}
