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
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.isSkeletonable = true
            
            collectionView.register(UINib(nibName: "AccountCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: K.Questionnaire.cell1Identifier)
            collectionView.register(UINib(nibName: "QuestionnaireCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: K.Questionnaire.cell2Identifier)
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    private let db = Firestore.firestore()
    private var currentUser: User? = Auth.auth().currentUser
    
    private var questionnaires: [Questionnaire] = []
    private var questionnairesCompletion = [String: Bool]()
    private var selectedQuestionnaire = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { [weak self] in
            await self?.loadQuestionnaires()
        }
        
        collectionView.prepareSkeleton(completion: { done in
            self.collectionView.showAnimatedGradientSkeleton(usingGradient: K.gradient)
        })
        
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
    
    @MainActor
    private func loadQuestionnaires() async {
        do {
            let document = try await db.collection(K.FStore.Student.collectionName).document(currentUser?.uid ?? "").getDocument()
            questionnaires = []
            
            guard let questionnairesId = document.get(K.FStore.Student.questionnaires) as? [String: Bool] else { return print("Document does not exist") }

            for (id, complete) in questionnairesId {
                if questionnairesCompletion[id] == nil {
                    questionnairesCompletion[id] = complete
                }

                await getQuestionnaire(with: id)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    private func getQuestionnaire(with id: String) async {
        do {
            let querySnapshot = try await db.collection(K.FStore.Questionnaire.collectionName).document(id).getDocument()
            guard querySnapshot.exists else { return print("Document does not exist") }
            
            let innerQuerySnapshot = try await querySnapshot.reference.collection(K.FStore.Questionnaire.childCollectionName).getDocuments()
            let questions = innerQuerySnapshot.documents.compactMap { Question(no: $0.documentID, dictionary: $0.data()) }
            
            if let questionnaire = Questionnaire(uid: querySnapshot.documentID, dictionaryField: querySnapshot.data() ?? [:], questions: questions) {
                questionnaires.append(questionnaire)
            }
            
            collectionView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

//MARK: - SkeletonCollectionViewDataSource

extension QuestionnaireViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + questionnaires.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return indexPath.row == 0 ? K.Questionnaire.cell1Identifier : K.Questionnaire.cell2Identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
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
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, prepareCellForSkeleton cell: UICollectionViewCell, at indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = cell as? AccountCollectionViewCell
            cell?.isSkeletonable = true
        } else {
            let cell = cell as? QuestionnaireCollectionViewCell
            cell?.isSkeletonable = true
        }
    }
    
    //MARK: - UICollectionViewDataSource
    
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
