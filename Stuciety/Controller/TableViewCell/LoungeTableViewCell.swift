//
//  LoungeTableViewCell.swift
//  Stuciety
//
//  Created by bryan colin on 3/27/21.
//

import UIKit

protocol TableViewInsideCollectionViewDelegate: UIViewController {
    func cellTaped(topic: Topic?)
}

class LoungeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: TableViewInsideCollectionViewDelegate?
    var topics: [Topic]?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK: - UICollectionViewDelegate

extension LoungeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.LoungeTable.collectionCellIdentifier, for: indexPath) as! LoungeCollectionViewCell
        let topic = topics?[indexPath.item]
        cell.topic = topic
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height - (collectionView.safeAreaInsets.top + collectionView.safeAreaInsets.bottom))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let destinationVC = storyboard.instantiateViewController(identifier: K.chatVC) as! ChatViewController
//        destinationVC.roomTitle = topics?[indexPath.item].label
        self.delegate?.cellTaped(topic: topics?[indexPath.item])
    }

}
