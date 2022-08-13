//
//  CounselorViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/13/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class CounselorViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "CounselorTableViewCell", bundle: nil), forCellReuseIdentifier: K.Counselor.cellIdentifier)
        }
    }
    
    private let db = Firestore.firestore()
    private var counselors: [Counselor] = []
    private var selectedCounselor: Counselor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { [weak self] in
            await self?.loadCounselors()
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if tableView != nil {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Counselor.Segue.details {
            if let destinationVC = segue.destination as? CounselorDetailsViewController {
                destinationVC.counselorDetails = selectedCounselor
            }
        }
    }
    
    @MainActor
    func loadCounselors() async {
        do {
            let querySnapshot = try await db.collection(K.FStore.Counselor.collectionName).getDocuments()
            counselors = querySnapshot.documents.compactMap { QueryDocumentSnapshot -> Counselor? in
                return try? QueryDocumentSnapshot.data(as: Counselor.self)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

//MARK: - UITableViewDataSource

extension CounselorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counselors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.Counselor.cellIdentifier, for: indexPath) as? CounselorTableViewCell else {
            fatalError("Unable to create counselor table view cell")
        }
        cell.counselor = counselors[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CounselorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCounselor = counselors[indexPath.row]
        performSegue(withIdentifier: K.Counselor.Segue.details, sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /// an enum of type TableAnimation - determines the animation to be applied to the tableViewCells
        let currentTableAnimation: TableAnimation = .fadeIn(duration: 0.5, delay: 0.03)
        
        /// fetch the animation from the TableAnimation enum and initialze the TableViewAnimator class
        let animation = currentTableAnimation.getAnimation()
        let animator = TableViewAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
}


