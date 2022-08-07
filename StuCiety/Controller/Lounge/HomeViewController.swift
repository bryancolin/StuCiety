//
//  HomeViewController.swift
//  Stuciety
//
//  Created by bryan colin on 3/19/21.
//

import UIKit
import Firebase
import SkeletonView

protocol CollectionViewCellTapDelegate: AnyObject {
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
        
        Task { [weak self] in
            await self?.loadRooms()
            self?.tableView.reloadData()
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
    
    @MainActor
    private func loadRooms() async {
        do {
            let querySnapshot = try await db.collection("rooms").getDocuments()
            let rooms = querySnapshot.documents.compactMap { (QueryDocumentSnapshot) -> Room? in
                return try? QueryDocumentSnapshot.data(as: Room.self)
            }
            categorizeRooms = Dictionary(grouping: rooms, by: { $0.category.rawValue })
            roomKeys = Array(categorizeRooms.keys.sorted())
        } catch {
            print("No documents")
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

//MARK: - CollectionViewCellTapDelegate

extension HomeViewController: CollectionViewCellTapDelegate {
    
    func cellTaped(room: Room?) {
        selectedRoom = room
        performSegue(withIdentifier: K.Segue.chat, sender: self)
    }
}

