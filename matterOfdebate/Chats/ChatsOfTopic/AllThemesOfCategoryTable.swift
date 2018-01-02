//
//  AllThemesOfCategoryTable.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 20.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseStorageUI

class AllThemesOfCategoryTable: UITableViewController {
    private let storage = Storage.storage()
    
    var category : Category?
    private var topics: [Topic] = []
    private var themesUpdateHandle: DatabaseHandle?
    private var themesRef : DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // empty topics object
        topics = []
        
        // unwrap category object
        guard let category_obj = self.category else {
            return
        }
        print("Now displaying themes of " + category_obj.title)
        
        // set title of table view controller
        self.title = category_obj.title
        
        // get all themes of category
        self.getThemesOfCategory(category_obj.title)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // remove observer
        if let ref = themesRef {
            ref.removeObserver(withHandle: themesUpdateHandle!)
        }
    }
    
    func getThemesOfCategory(_ theme_id: String) {
        
        themesRef = Constants.refs.databaseThemes
        themesUpdateHandle = themesRef!.queryOrdered(byChild: "categories/" + theme_id)
            .queryEqual(toValue: true)
            .observe(.childAdded, with: { (snapshot) -> Void in
        
                let themesData = snapshot.value as! Dictionary<String, AnyObject>
                let t_title = themesData["titel"] as? String ?? ""
                let img_url = themesData["img-url"] as? String ?? ""
                let description = themesData["description"] as? String ?? ""
                
                let topic = Topic(name: t_title, description: description, categories: [theme_id], imageUrl: img_url, id: snapshot.key)
                
                self.topics.append(topic)
                self.tableView.reloadData()
            })
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    // click on chat row should show all chats of that theme
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        self.performSegue(withIdentifier: "showChatsOfTopic", sender: topic)
    }
    
    // give topic to next controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let topic = sender as? Topic {
            let chatsTableView = segue.destination as! ChatsOfTopicTableVC
            chatsTableView.topic = topic
        }
        
    }
    

    // define whats in the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "detailThemeCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? detailThemeCell else {
            fatalError("The dequeued cell is not an instance of detailThemeCell.")
        }
        
        let topic = topics[indexPath.row]
        
        // set cell content
        cell.titleLabel.text = topic.title
        cell.descLabel.text = topic.description
        
        // use firebase and sd web image to load picture asnyc
        let reference = self.storage.reference(forURL: topic.imageUrl)
        cell.imgView.sd_setImage(with: reference, placeholderImage: nil)
        
        return cell
    }
    
}
