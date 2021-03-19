//
//  HomeViewController.swift
//  Stuciety
//
//  Created by bryan colin on 3/19/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener { auth, user in
          if let currentUser = user {
            // User is signed in. Show home screen
            print(currentUser)
          } else {
            // No User is signed in. Show user the login screen
            print("No User is signed in")
          }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
