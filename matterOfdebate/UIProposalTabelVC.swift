//
//  UIProposalTabelVC.swift
//  matterOfdebate
//
//  Created by Gregor Anzer on 24.01.18.
//  Copyright © 2018 Gruppe7. All rights reserved.
//

import UIKit

class UIProposalTabelVC: UITableViewController {
    
    var proposals = [Proposal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        let p1 = Proposal(t: "Titel wefwa weaf faega erga wa", d: "Tas feaeg  eargae wfwef wag feaeg  eargae wfwef wag feaeg  eargae wfwef wag feaeg  eargae wfwef wag", i: "23415316352")
        let p2 = Proposal(t: "Titel2 wefwa weaf faega erga wa", d: "Tas feaeg  eargae wfwef wag feaeg  eargae wfwef wag feaeg  eargae wfwef wag feaeg  eargae wfwef wag", i: "23415316354")
        let p3 = Proposal(t: "Titel3 wefwa weaf faega erga wa", d: "Tas feaeg  eargae wfwef wag feaeg  eargae wfwef wag feaeg  eargae wfwef wag feaeg  eargae wfwef wag", i: "23415316354")
        
        proposals += [p1, p2, p3]
        
        
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
        cell.lableP.text = proposedTheme.title
        cell.textP.text = proposedTheme.description
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
