//
//  CollectionTableViewController.swift
//  ios-collection-coredata
//
//  Created by Conner on 8/4/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class CollectionTableViewController: UITableViewController {
    var items: [Item] = []
    
    override func viewWillAppear(_ animated: Bool) {
        getItems()
    }
    
    func getItems() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            do {
                let itemsFromCD = try context.fetch(Item.fetchRequest())
                if let fetchedItems = itemsFromCD as? [Item] {
                    items = fetchedItems
                    tableView.reloadData()
                }
            } catch {
                NSLog("\(error)")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        if let imageData = item.image {
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(items[indexPath.row])
            }
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            getItems()
        }
    }
}
