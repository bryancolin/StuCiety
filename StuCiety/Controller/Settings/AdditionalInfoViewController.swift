//
//  AdditionalInfoViewController.swift
//  Stuciety
//
//  Created by bryan colin on 5/1/21.
//

import UIKit

class AdditionalInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let infos = Info.fetchInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: K.AdditionalInfo.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - UITableViewDataSource

extension AdditionalInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.AdditionalInfo.cellIdentifier, for: indexPath) as? InfoTableViewCell else {
            fatalError("Unable to create topic collection view cell")
        }
        cell.configure(title: infos[indexPath.row].title, description: infos[indexPath.row].description, image: infos[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

//MARK: - UITableViewDelegate

extension AdditionalInfoViewController: UITableViewDelegate {
    
}
