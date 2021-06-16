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
    
    private let db = Firestore.firestore()
    private var currentUser: User? = Auth.auth().currentUser
    
    private var questionnaires: [Questionnaire] = []
    private var questionnairesCompletion = [String: Bool]()
    private var selectedQuestionnaire = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "AccountCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: K.Questionnaire.cell1Identifier)
        collectionView.register(UINib(nibName: "QuestionnaireCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: K.Questionnaire.cell2Identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        DispatchQueue.global().async {
            DispatchQueue.main.async { [self] in
                loadQuestionnaires()
            }
        }
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
        if collectionView != nil {
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Questionnaire.Segue.start {
            if let destinationVC = segue.destination as? QuestionHomeViewController {
                let questionnaire = questionnaires[selectedQuestionnaire - 1]
                destinationVC.questionnaire = questionnaire
                destinationVC.previousAnswers = questionnairesCompletion[questionnaire.id] ?? false
            }
        }
    }
    
    func loadQuestionnaires() {
        db.collection(K.FStore.Student.collectionName).document(currentUser?.uid ?? "").addSnapshotListener {[self] (document, error) in
            questionnaires = []
            
            guard let document = document, document.exists, let questionnairesId = document.get(K.FStore.Student.questionnaires) as? [String: Bool] else { return print("Document does not exist") }
            
            for (id, complete) in questionnairesId {
                if questionnairesCompletion[id] == nil {
                    questionnairesCompletion[id] = complete
                }
                
                db.collection(K.FStore.Questionnaire.collectionName).document(id).getDocument {[self] (document, error) in
                    guard let document = document, document.exists else { return print("Document does not exist") }
                    guard let data = document.data() else {return print("Document data not found")}
                    
                    document.reference.collection(K.FStore.Questionnaire.childCollectionName).getDocuments { (querySnapshot, error) in
                        guard error == nil else { return print("Error getting documents") }
                        guard let snapshotDocuments = querySnapshot?.documents else { return print("No documents") }
                        
                        var questions: [Question] = []
                        for doc in snapshotDocuments {
                            if let question = Question(no: doc.documentID, dictionary: doc.data()) {
                                questions.append(question)
                            }
                        }
                        
                        if let questionnaire = Questionnaire(uid: document.documentID, dictionaryField: data, questions: questions) {
                            questionnaires.append(questionnaire)
                        }
                        
                        collectionView.hideSkeleton(transition: .crossDissolve(0.25))
                        collectionView.reloadData()
                    }
                }
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
        return indexPath.row == 0 ? K.Questionnaire.cell1Identifier : K.Questionnaire.cell2Identifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + questionnaires.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: K.Questionnaire.cell1Identifier, for: indexPath) as? AccountCollectionViewCell else {
                fatalError("Unable to create account collection view cell")
            }
            cell1.configure()
            return cell1
        } else {
            guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: K.Questionnaire.cell2Identifier, for: indexPath) as? QuestionnaireCollectionViewCell else {
                fatalError("Unable to create questionnaire collection view cell")
            }
            let questionnaire = questionnaires[indexPath.row - 1]
            cell2.configure(name: questionnaire.title, complete: questionnairesCompletion[questionnaire.id] ?? false)
            return cell2
        }
    }
}

//MARK: - UICollectionViewDelegate

extension QuestionnaireViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: K.Segue.account, sender: self)
        } else {
            selectedQuestionnaire = indexPath.row
            performSegue(withIdentifier: K.Questionnaire.Segue.start, sender: self)
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
