//
//  ChatViewController.swift
//  Stuciety
//
//  Created by bryan colin on 3/27/21.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var roomTitle: String?
    
    var messages = ["Hello", "test"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor(named: K.BrandColors.purple)
        self.title = roomTitle
        
        tableView.dataSource = self
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Room.cellIdentifier, for: indexPath) as UITableViewCell
        cell.textLabel?.text = messages[indexPath.row]
        
        return cell
    }
}
