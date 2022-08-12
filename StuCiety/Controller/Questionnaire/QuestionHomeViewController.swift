//
//  StartViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/23/21.
//

import UIKit
import Firebase
import ProgressHUD

class QuestionHomeViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    
    private let db = Firestore.firestore()
    private var currentUser: User? = Auth.auth().currentUser
    
    var questionnaire: Questionnaire?
    var previousAnswers: Bool = false
    var questionsAnswered: Bool = false
    private var completionText = "Thank you for your time filling in the questionnaire, we will update your result and notify the counselor."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = !questionsAnswered ? "Start" : "Finish"
        self.navigationItem.setHidesBackButton(questionsAnswered, animated: true)
        updateUI()
        
        Task { [weak self] in
            await self?.loadPreviousAnswer()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Questionnaire.Segue.question {
            if let destinationVC = segue.destination as? QuestionViewController {
                destinationVC.questionnaire = questionnaire
            }
        }
    }
    
    private func updateUI() {
        guard let questionnaire = questionnaire else { return }
        descriptionLabel.text = !questionsAnswered ? questionnaire.description : completionText
        buttonLabel.setTitle(!questionsAnswered ? "Start" : "Complete", for: .normal)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if !questionsAnswered {
            performSegue(withIdentifier: K.Questionnaire.Segue.question, sender: self)
        } else {
            Task { [weak self] in
                await self?.saveResult()
            }
            
            let controllers = self.navigationController?.viewControllers
            for vc in controllers! {
                if vc is QuestionnaireViewController {
                    self.navigationController?.popToViewController(vc as! QuestionnaireViewController, animated: true)
                }
            }
        }
    }
    
    private func loadPreviousAnswer() async {
        guard let user = currentUser, previousAnswers && !questionsAnswered else { return }
        
        let dbRef = db.collection(K.FStore.Student.collectionName).document(user.uid).collection(K.FStore.Questionnaire.collectionName).document(questionnaire?.id ?? "-1")
        
        do {
            let querySnapshot = try await dbRef.getDocument()
            
            let innerQuerySnapshot = try await querySnapshot.reference.collection(K.FStore.Questionnaire.childCollectionName).getDocuments()
            questionnaire?.questions = innerQuerySnapshot.documents.compactMap { QueryDocumentSnapshot -> Question? in
                return try? QueryDocumentSnapshot.data(as: Question.self)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func saveResult() async {
        guard let user = currentUser, let questionnaire = questionnaire else { return }
        
        do {
            try await db.collection(K.FStore.Student.collectionName).document(currentUser?.uid ?? "0").updateData([
                K.FStore.Student.questionnaires: [ questionnaire.id: questionsAnswered ]
            ])
        } catch {
            ProgressHUD.showFailed("Error saving user result")
        }
        
        do {
            let dbRef = db.collection(K.FStore.Student.collectionName).document(user.uid).collection(K.FStore.Questionnaire.collectionName).document(questionnaire.id)
            
            try await dbRef.setData([
                K.FStore.Questionnaire.description: questionnaire.description,
                K.FStore.Questionnaire.createdBy: questionnaire.createdBy,
                K.FStore.Questionnaire.title: questionnaire.title,
                K.FStore.Questionnaire.result: ""
            ])
            
            for question in questionnaire.questions {
                try dbRef.collection(K.FStore.Questionnaire.childCollectionName).document(question.id ?? "-1").setData(from: question)
                print("Document successfully written!")
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
