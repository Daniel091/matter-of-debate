//
//  UIProposalTabelVC.swift
//  matterOfdebate
//
//  Created by Gregor Anzer on 24.01.18.
//  Copyright © 2018 Gruppe7. All rights reserved.
//

import UIKit
import Firebase

class UIProposalTabelVC: UITableViewController {
    
    var proposals = [Proposal]()
    var selectedProposal = Proposal(t: "", d: "", i: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        Constants.refs.databaseProposals.observe(DataEventType.value, with: { (snapshot) in
            let pDictionary = snapshot.value as? [String : AnyObject]
            let elements = pDictionary?.values
            
            // unfolding the data and adding it to the array
            var items: [Proposal] = []
            for datablock in pDictionary! {
                let pID: String = datablock.key
                let pTitle: String = datablock.value["title"] as! String
                let pDescr: String = datablock.value["description"] as! String
                let temp: Proposal = Proposal(t: pTitle, d: pDescr, i: pID)
                items.append(temp)
            }
            
            // reloading data
            self.proposals = items
            self.tableView.reloadData()
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let viewController = segue.destination as? CreateDiscThemeViewController {
            viewController.selectedProposal = selectedProposal
            viewController.isProposed = true
        }
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return proposals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "UIProposalCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UIProposalCell else {
            fatalError("The dequeed cell is not instance of UIProposalCell")
        }
        // Configure the cell...
        let proposedTheme = proposals[indexPath.row]
        cell.titleView.text = proposedTheme.title
        cell.textView.text = proposedTheme.description
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProposal = proposals[indexPath.row]
        performSegue(withIdentifier: "toCreateTheme", sender: self)
    }
    
    //Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        //Return false if you do not want the specified item to be editable.
//        return true
//    }
 

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
