//
//  SettingsViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/3/21.
//

import UIKit
import Firebase
import ProgressHUD

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var lists = ["Account", "Notifications", "About", "Additional Info", "", "", "", "Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            ProgressHUD.showFailed("Error signing out \(signOutError)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Settings.Segue.account {
            _ = segue.destination as! AccountViewController
        }
    }
}

//MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Settings.cellIdentifier, for: indexPath)
        cell.textLabel?.text = lists[indexPath.row]
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: K.Settings.Segue.account, sender: self)
            break
        case 7:
            signOut()
            break
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.textLabel?.textColor = UIColor(named: K.BrandColors.purple)
        cell.tintColor = UIColor(named: K.BrandColors.purple)
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textAlignment = .left
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(named: K.BrandColors.lightBlue) : .white
        
        if indexPath.row >= 4 {
            cell.accessoryType = .none
            cell.backgroundColor = .white
            if indexPath.row == 7 {
                cell.textLabel?.textAlignment = .center
                cell.backgroundColor = UIColor(named: K.BrandColors.lightBlue)
            }
        }
    }
}
