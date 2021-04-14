//
//  CounselorViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/13/21.
//

import UIKit

class CounselorViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedCounselor: Counselor?
    
    let counselors: [Counselor] = [
        Counselor(id: "1", displayName: "Kevin", email: "kevin@staff.com", biography: "I'm Dr Psych, your consultation counselors. I'll be explaining how this counseling works. I'm a professional licensed counselors - so you can feel comfortable openly sharing your concerns with me.", area: ["Depression", "Anxiety"], license: ["Licensed Mental Health Counselor", "LMHC 000001"], photoURL: "a"),
        Counselor(id: "1", displayName: "Bryan", email: "kevin@staff.com", biography: "I'm Dr Psych, your consultation counselors. I'll be explaining how this counseling works. I'm a professional licensed counselors - so you can feel comfortable openly sharing your concerns with me.", area: ["Depression", "Anxiety"], license: ["Licensed Mental Health Counselor", "LMHC 000001"], photoURL: "a")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.CounselorTable.Segue.details {
            if let destinationVC = segue.destination as? CounselorDetailsViewController {
                destinationVC.counselorDetails = selectedCounselor
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
}


