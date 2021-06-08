//
//  HomeViewController.swift
//  Stuciety
//
//  Created by bryan colin on 3/19/21.
//

import UIKit
import Firebase
import SkeletonView

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let db = Firestore.firestore()
    private var structureRooms: [[Room]] = [[Room]]()
    private var selectedRoom: Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        DispatchQueue.global().async {
            DispatchQueue.main.async { [self] in
                loadRooms()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.isSkeletonable = true
        
        if structureRooms.isEmpty {
            tableView.showAnimatedGradientSkeleton(usingGradient: K.gradient)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            tableView.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.chat {
            if let destinationVC = segue.destination as? ChatViewController {
                destinationVC.roomTitle = selectedRoom?.name ?? "Room"
            }
        }
    }
    
    private func loadRooms() {
        var rooms: [Room] = []
        
        db.collection("rooms").getDocuments { [self] (querySnapshot, error) in
            guard error == nil else { return print("There was an issue retrieving data from Firestore.") }
            guard let snapshotDocuments = querySnapshot?.documents else { return print("No documents") }
            
            rooms = snapshotDocuments.compactMap { (QueryDocumentSnapshot) -> Room? in
                return try? QueryDocumentSnapshot.data(as: Room.self)
            }
            
            categorizing(rooms)
        }
    }
    
    private func categorizing(_ rooms: [Room]) {
        var general: [Room] = []
        var subjects: [Room] = []
        
        for room in rooms {
            switch room.category {
            case "General":
                general.append(room)
            case "Subjects":
                subjects.append(room)
            default:
                return
            }
        }
        
        structureRooms.append(general)
        structureRooms.append(subjects)
        
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return structureRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.LoungeTable.cellIdentifier, for: indexPath) as? LoungeTableViewCell else {
            fatalError("Unable to create topic table view cell")
        }
        let rooms = structureRooms[indexPath.row]
        cell.rooms = rooms
        cell.category = rooms[0].category
        cell.delegate = self
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

extension HomeViewController: TableViewInsideCollectionViewDelegate {
    
    func cellTaped(room: Room?) {
        selectedRoom = room
        self.performSegue(withIdentifier: K.Segue.chat, sender: self)
    }
}

