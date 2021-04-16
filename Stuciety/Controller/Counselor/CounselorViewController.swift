//
//  CounselorViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/13/21.
//

import UIKit
import Firebase

class CounselorViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var counselors: [Counselor] = []
    var selectedCounselor: Counselor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        loadCounselors()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.CounselorTable.Segue.details {
            if let destinationVC = segue.destination as? CounselorDetailsViewController {
                destinationVC.counselorDetails = selectedCounselor
            }
        }
    }
    
    func loadCounselors() {
        db.collection(K.FStore.Counselor.collectionName).addSnapshotListener { [self] (querySnapshot, err) in
            if let e = err {
                print("Error getting documents: \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        if let counselor = Counselor(uid: doc.documentID, dictionary: doc.data()) {
                            counselors.append(counselor)
                        }
                    }
                }
                
                tableView.reloadData()
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension CounselorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counselors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CounselorTable.cellIdentifier, for: indexPath) as! CounselorTableViewCell
        cell.counselor = counselors[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CounselorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCounselor = counselors[indexPath.row]
        self.performSegue(withIdentifier: K.CounselorTable.Segue.details, sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /// an enum of type TableAnimation - determines the animation to be applied to the tableViewCells
        let currentTableAnimation: TableAnimation = .fadeIn(duration: 0.85, delay: 0.03)
        
        /// fetch the animation from the TableAnimation enum and initialze the TableViewAnimator class
        let animation = currentTableAnimation.getAnimation()
        let animator = TableViewAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
}


