//
//  SideMenuTableViewController.swift
//  StuCiety
//
//  Created by bryan colin on 6/9/21.
//

import UIKit
import SDWebImage
import SideMenu

class SideMenuTableViewController: UITableViewController {
    
    var usersId = [String]()
    typealias tuple = (displayName: String, photoURL: String)
    var users = [String: tuple]() {
        didSet {
            usersId = Array(users.keys)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: K.SideMenu.cellIdentifier)
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.SideMenu.cellIdentifier, for: indexPath) as? SideMenuTableViewCell else {
            fatalError("Unable to create side menu table view cell")
        }
        let key = usersId[indexPath.row]
        cell.configure(name: users[key]?.displayName ?? "", photoURL: users[key]?.photoURL ?? "")
        
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
