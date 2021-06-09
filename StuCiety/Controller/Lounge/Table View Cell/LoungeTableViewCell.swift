//
//  LoungeTableViewCell.swift
//  Stuciety
//
//  Created by bryan colin on 3/27/21.
//

import UIKit

protocol TableViewInsideCollectionViewDelegate {
    func cellTaped(room: Room?)
}

class LoungeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var roomCategory: UILabel!
    
    var delegate: TableViewInsideCollectionViewDelegate?
    var rooms: [Room]?
    var category: String! {
        didSet {
            self.updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "LoungeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: K.Lounge.collectionCellIdentifier)
        
        roomCategory.lastLineFillPercent = 50
        roomCategory.linesCornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI() {
        if let title = category {
            roomCategory.text = title
        }
    }
}

//MARK: - UICollectionViewDelegate

extension LoungeTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Lounge.collectionCellIdentifier, for: indexPath) as? LoungeCollectionViewCell else {
            fatalError("Unable to create room collection view cell")
        }
        cell.room = rooms?[indexPath.item]
        cell.delegate = delegate
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.cellTaped(room: rooms?[indexPath.item])
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
        return CGSize(width: 200, height: 200)
    }
}
