//
//  ChatViewController.swift
//  Stuciety
//
//  Created by bryan colin on 3/27/21.
//

import UIKit

class ChatViewController: UIViewController {
    
    var roomTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor(named: K.BrandColors.purple)
        self.title = roomTitle
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
