//
//  AllChatsTableView.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 20.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit

// TODO rename to CategoriesTableView
class AllChatsTableView: UITableViewController {
    
    private var categories: [Category] = []
    
    // triggered when view is loaded the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = CategoryViewModel.sharedInstance.categories
        self.tableView.reloadData()
    }

    // only one section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // click on chat row should show chat view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = categories[indexPath.row]
        self.performSegue(withIdentifier: "showThemes", sender: topic)
    }
    
    // give topic to next controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let category = sender as? Category {
            let topicTableView = segue.destination as! AllThemesOfCategoryTable
            topicTableView.category = category
        }
        
    }

    // define whats in the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoryCell  else {
            fatalError("The dequeued cell is not an instance of CategoryCell.")
        }
        
        let categorie = categories[indexPath.row]
        
        // set cell content
        cell.topicText.text = categorie.title
        
        return cell
    }
}
