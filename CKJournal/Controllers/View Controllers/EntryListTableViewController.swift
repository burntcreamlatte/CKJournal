//
//  EntryListTableViewController.swift
//  CKJournal
//
//  Created by Aaron Shackelford on 12/9/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {

    // MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.shared.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = EntryController.shared.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.timestamp.formattedString()
        
        return cell
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        EntryController.shared.fetchEntries { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //iidoo
        if segue.identifier == "toEditEntry" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            if let destinationVC = segue.destination as? EntryDetailViewController {
                let entry = EntryController.shared.entries[indexPath.row]
                destinationVC.entry = entry
            }
        }
    }
}
