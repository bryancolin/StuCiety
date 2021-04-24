//
//  QuestionnaireViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/20/21.
//

import UIKit
import Firebase
import SkeletonView

class QuestionnaireViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var currentUser: User? = Auth.auth().currentUser
    
    var questionnaires: [Questionnaire] = [
        Questionnaire(id: "1", title: "Health", description: "This is health sample", createdBy: "Bryan", question:
                        [Question(text: "Are you happy?"), Question(text: "Are you sad?")]),
        Questionnaire(id: "2", title: "Wellness", description: "This is welness sample", createdBy: "Bryan", question: [Question(text: "Are you Healthy?")])
    ]
    var selectedQuestionnaire = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "AccountCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: K.QuestionnaireCollection.cell1Identifier)
        collectionView.register(UINib(nibName: "QuestionnaireCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: K.QuestionnaireCollection.cell2Identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.isSkeletonable = true
        collectionView.showAnimatedGradientSkeleton(usingGradient: K.gradient)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            collectionView.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.QuestionnaireCollection.Segue.start {
            if let destinationVC = segue.destination as? StartViewController {
                destinationVC.questionnaire = questionnaires[selectedQuestionnaire - 1]
            }
        }
    }
}

//MARK: - SkeletonCollectionViewDataSource

extension QuestionnaireViewController: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + questionnaires.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return indexPath.row == 0 ? K.QuestionnaireCollection.cell1Identifier : K.QuestionnaireCollection.cell2Identifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + questionnaires.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: K.QuestionnaireCollection.cell1Identifier, for: indexPath) as? AccountCollectionViewCell else {
                fatalError("Unable to create topic collection view cell")
            }
            cell1.configure()
            return cell1
        } else {
            guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: K.QuestionnaireCollection.cell2Identifier, for: indexPath) as? QuestionnaireCollectionViewCell else {
                fatalError("Unable to create topic collection view cell")
            }
            cell2.configure(name: questionnaires[indexPath.row - 1].title)
            return cell2
        }
    }
}

//MARK: - UICollectionViewDelegate

extension QuestionnaireViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: K.Segue.account, sender: self)
        } else {
            selectedQuestionnaire = indexPath.row
            self.performSegue(withIdentifier: K.QuestionnaireCollection.Segue.start, sender: self)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension QuestionnaireViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        
        let space: CGFloat = (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let spaceInBetween: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + space
        
        let height: CGFloat = (collectionView.frame.size.width - spaceInBetween) / 2.0
        let width: CGFloat = indexPath.row == 0 ? (collectionView.frame.size.width - space) : height
        
        return CGSize(width: width, height: height)
    }
}
