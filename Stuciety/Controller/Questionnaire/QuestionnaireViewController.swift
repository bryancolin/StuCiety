//
//  QuestionnaireViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/20/21.
//

import UIKit
import Firebase
import SkeletonView
import Firebase

class QuestionnaireViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let db = Firestore.firestore()
    var currentUser: User? = Auth.auth().currentUser
    
    var questionnaires: [Questionnaire] = []
    var selectedQuestionnaire = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "AccountCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: K.QuestionnaireCollection.cell1Identifier)
        collectionView.register(UINib(nibName: "QuestionnaireCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: K.QuestionnaireCollection.cell2Identifier)
        
        loadQuestionnaires()
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
            if let destinationVC = segue.destination as? QuestionHomeViewController {
                destinationVC.questionnaire = questionnaires[selectedQuestionnaire - 1]
                destinationVC.complete = false
            }
        }
    }
    
    func loadQuestionnaires() {
        db.collection(K.FStore.Student.collectionName).document(currentUser?.uid ?? "").getDocument {[self] (document, error) in
            if let document = document, document.exists {
                
                if let questionnairesId = document.get(K.FStore.Student.questionnaires) as? [String] {
                    for questionnaireId in questionnairesId {
                        
                        db.collection(K.FStore.Questionnaire.collectionName).document(questionnaireId).getDocument {[self] (document, error) in
                            if let document = document, document.exists {
                                if let data = document.data() {
                                    document.reference.collection(K.FStore.Questionnaire.childCollectionName).getDocuments { (querySnapshot, error) in
                                        if let e = error {
                                            print("Error getting documents: \(e)")
                                        } else {
                                            if let snapshotDocuments = querySnapshot?.documents {
                                                var questions: [Question] = []
                                                
                                                for doc in snapshotDocuments {
                                                    if let question = Question(dictionary: doc.data()) {
                                                        questions.append(question)
                                                    }
                                                }
                                                
                                                if let questionnaire = Questionnaire(uid: document.documentID, dictionaryField: data, questions: questions) {
                                                    questionnaires.append(questionnaire)
                                                }
                                            }
                                            
                                            collectionView.reloadData()
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            } else {
                print("Document does not exist")
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
