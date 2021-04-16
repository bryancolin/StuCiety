//
//  HomeViewController.swift
//  Stuciety
//
//  Created by bryan colin on 3/19/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableList: UITableView!
    
    var topics = Topic.fetchTopics()
    var selectedTopic: Topic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableList.dataSource = self
        tableList.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.chat {
            if let destinationVC = segue.destination as? LoungeRoomViewController {
                destinationVC.roomTitle = selectedTopic?.label
            }
        }
    }
}

//MARK: - TableViewDataSource

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.LoungeTable.cellIdentifier, for: indexPath) as? LoungeTableViewCell else {
            fatalError("Unable to create topic table view cell")
        }
        let topic = topics[indexPath.row]
        cell.delegate = self
        cell.topics = topic
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

extension HomeViewController: TableViewInsideCollectionViewDelegate {
    func cellTaped(topic: Topic?) {
        selectedTopic = topic
        self.performSegue(withIdentifier: K.Segue.chat, sender: self)
    }
}

