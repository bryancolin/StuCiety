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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet var aboutView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    var effect: UIVisualEffect!
    
    var lists = ["Account", "Notifications", "About", "Additional Info", "", "", "", "Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Visual Effect
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.isHidden = true
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            ProgressHUD.showFailed("Error signing out \(signOutError)")
        }
    }
    
    private func showAbout() {
        self.view.addSubview(aboutView)
        aboutView.center = self.view.center
        aboutView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        aboutView.alpha = 0
        
        // Add animation on About Pop Up View
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.isHidden = false
            self.visualEffectView.effect = self.effect
            self.aboutView.alpha = 1
            self.aboutView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction private func quitAbout(_ sender: UIButton) {
        // Add out animation on About Pop Up View
        UIView.animate(withDuration: 0.3, animations: {
            self.aboutView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.aboutView.alpha = 0
            
            self.visualEffectView.effect = nil
        }) { (success: Bool) in
            self.aboutView.removeFromSuperview()
            self.visualEffectView.isHidden = true
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
        let cell = tableView.cellForRow(at: indexPath)
        
        switch cell?.textLabel?.text {
        case "Account":
            performSegue(withIdentifier: K.Segue.account, sender: self)
        case "About":
            showAbout()
        case "Additional Info":
            performSegue(withIdentifier: K.Segue.info, sender: self)
        case "Sign Out":
            signOut()
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
        
        guard indexPath.row >= 4 else { return }
        cell.accessoryType = .none
        cell.backgroundColor = .white
        
        guard indexPath.row == 7 else { return }
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = UIColor(named: K.BrandColors.lightBlue)
    }
}
