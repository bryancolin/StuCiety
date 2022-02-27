//
//  HomeViewController.swift
//  Stuciety
//
//  Created by bryan colin on 3/19/21.
//

import UIKit
import Firebase
import SkeletonView

protocol CollectionViewDelegate: AnyObject {
    func cellTaped(room: Room?)
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    private let db = Firestore.firestore()

    private var categorizeRooms = [String: [Room]]()
    private var roomKeys = [String]()
    private var selectedRoom: Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            DispatchQueue.main.async { [self] in
                loadRooms()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.chat {
            if let destinationVC = segue.destination as? ChatViewController {
                destinationVC.roomTitle = selectedRoom?.name ?? "Room"
            }
        }
    }
    
    private func loadRooms() {
        db.collection("rooms").getDocuments { [self] (querySnapshot, error) in
            guard error == nil else { return print("There was an issue retrieving data from Firestore.") }
            guard let snapshotDocuments = querySnapshot?.documents else { return print("No documents") }
            
            let rooms: [Room] = snapshotDocuments.compactMap { (QueryDocumentSnapshot) -> Room? in
                return try? QueryDocumentSnapshot.data(as: Room.self)
            }

            categorizeRooms = Dictionary(grouping: rooms, by: { $0.category.rawValue })
            roomKeys = Array(categorizeRooms.keys.sorted())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorizeRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.Lounge.cellIdentifier, for: indexPath) as? LoungeTableViewCell else {
            fatalError("Unable to create room table view cell")
        }
        let key = roomKeys[indexPath.row]
        cell.category = key
        cell.rooms = categorizeRooms[key]
        cell.delegate = self
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentTableAnimation: TableAnimation = .fadeIn(duration: 0.5, delay: 0.03)
        
        /// fetch the animation from the TableAnimation enum and initialze the TableViewAnimator class
        let animation = currentTableAnimation.getAnimation()
        let animator = TableViewAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
}

//MARK: - CollectionViewDelegate

extension HomeViewController: CollectionViewDelegate {
    
    func cellTaped(room: Room?) {
        selectedRoom = room
        performSegue(withIdentifier: K.Segue.chat, sender: self)
    }
}

