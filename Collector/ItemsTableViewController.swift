//
//  ItemsTableViewController.swift
//  Collector
//
//  Created by Ryan Miller on 4/12/18.
//  Copyright © 2018 Ryan Miller. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {

    //initialize empty array of items of core data type that will be populated from core data
    var items : [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //add function for calling getItems right before table appears
    override func viewWillAppear(_ animated: Bool) {
        getItems()
    }

    //write function to get items out of core data
    func getItems () {
        //use generic chunk of code to get access to context
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            //fetch data and return as array of Item objects -- however, this needs a "try?" with it, and since that returns an optional, need to unwrap with "if let"
            if let coreDataStuff = try? context.fetch(Item.fetchRequest()) as? [Item] {
                //need to unwrap ONE MORE TIME, since coreDataStuff is itself an optional array
                if let coreDataItems = coreDataStuff {
                    //FINALLY set items equal to items from core data
                    items = coreDataItems
                    //reload data so items are seen in table
                    tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //set number of rows equal to number of items from core data
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //remember to copy identifier name "reuseIdentifier" to prototype cell identifier in storyboard attributes
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        //pull out item at this row
        let item = items[indexPath.row]
        
        // Configure the cell...
        //get title
        cell.textLabel?.text = item.title
        //get image, but have to convert data back into UIImage. UImage() expects data, not data optional, so we have to unwrap item.image first
        if let imageData = item.image {
            //cells have a built-in imageView we can assign image to
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //get generic access to context:
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let item = items[indexPath.row]
                context.delete(item)
                //recall getItems() to get the new data, and this will automatically refresh the table data
                getItems()
            }
        }
    }

}
