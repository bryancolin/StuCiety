//
//  LoungeTableViewCell.swift
//  Stuciety
//
//  Created by bryan colin on 3/27/21.
//

import UIKit

protocol TableViewInsideCollectionViewDelegate {
    func cellTaped(topic: Topic?)
}

class LoungeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: TableViewInsideCollectionViewDelegate?
    var topics: [Topic]?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK: - UICollectionViewDelegate

extension LoungeTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.LoungeTable.collectionCellIdentifier, for: indexPath) as? LoungeCollectionViewCell else {
            fatalError("Unable to create collection view cell")
        }
        let topic = topics?[indexPath.item]
        cell.topic = topic
        cell.delegate = delegate
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.cellTaped(topic: topics?[indexPath.item])
    }

}

//MARK: - UICollectionViewDelegate

extension LoungeTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.masksToBounds = false
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension LoungeTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height - (collectionView.safeAreaInsets.top + collectionView.safeAreaInsets.bottom))
    }
}
