//
//  FriendsTableViewController.swift
//  FriendsApp
//
//  Created by Chirag Dodia on 4/17/25.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel:  UILabel!
    @IBOutlet weak var emailLabel:     UILabel!
}

class FriendsTableViewController: UITableViewController {
    private let cellID = "FriendCell"
    
    // Access the shared model
    private var model: FriendsModel {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to retrieve AppDelegate")
        }
        return appDelegate.friendsModel
    }
    
    // Raw & processed data
    private var allFriendsData: [[String]] = []
    private var groupedFriends     = [String: [[String]]]()
    private var sectionTitles      = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dynamic cell heights (optional)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        // Initial load
        allFriendsData = model.allTheFriends
        rebuildSections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh from model and reload
        allFriendsData = model.allTheFriends
        rebuildSections()
        tableView.reloadData()
    }
    
    // ✅ Add this method to allow external refreshing (e.g., from NewFriendViewController)
    func reloadData() {
        allFriendsData = model.allTheFriends
        rebuildSections()
        tableView.reloadData()
    }
    
    private func rebuildSections() {
        // 1. Sort by lastName, then firstName
        let sorted = allFriendsData.sorted { a, b in
            let aLast = a[1]
            let bLast = b[1]
            if aLast.caseInsensitiveCompare(bLast) == .orderedSame {
                return a[0].caseInsensitiveCompare(b[0]) == .orderedAscending
            }
            return aLast.caseInsensitiveCompare(bLast) == .orderedAscending
        }
        
        // 2. Group by first letter of lastName
        groupedFriends = Dictionary(grouping: sorted) { friend in
            String(friend[1].prefix(1)).uppercased()
        }
        
        // 3. Extract & sort section keys (A–Z)
        sectionTitles = groupedFriends.keys.sorted()
    }
    
    // MARK: – UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionTitles
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        let key = sectionTitles[section]
        return groupedFriends[key]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key  = sectionTitles[indexPath.section]
        let data = groupedFriends[key]![indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                as? FriendsTableViewCell else {
            fatalError("Cell \(cellID) is not a FriendsTableViewCell")
        }
        
        cell.firstNameLabel.text = data[0]
        cell.lastNameLabel.text  = data[1]
        cell.emailLabel.text     = data[2]
        
        return cell
    }
}
