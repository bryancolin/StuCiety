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
    var completionText = "Thank you for your time filling in the questionnaire, we will update your result and notify the counselor."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = !questionsAnswered ? "Start" : "Finish"
        self.navigationItem.setHidesBackButton(questionsAnswered, animated: true)
        updateUI()
        
        loadPreviousAnswer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Questionnaire.Segue.question {
            if let destinationVC = segue.destination as? QuestionViewController {
                destinationVC.questionnaire = questionnaire
            }
        }
    }
    
    func updateUI() {
        if let questionnaire = questionnaire {
            descriptionLabel.text = !questionsAnswered ? questionnaire.description : completionText
            buttonLabel.setTitle(!questionsAnswered ? "Start" : "Complete", for: .normal)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if !questionsAnswered {
            performSegue(withIdentifier: K.Questionnaire.Segue.question, sender: self)
        } else {
            saveResult()
            
            let controllers = self.navigationController?.viewControllers
            for vc in controllers! {
                if vc is QuestionnaireViewController {
                    self.navigationController?.popToViewController(vc as! QuestionnaireViewController, animated: true)
                }
            }
        }
    }
    
    func loadPreviousAnswer() {
        if let user = currentUser, previousAnswers && !questionsAnswered {
            let dbRef = db.collection(K.FStore.Student.collectionName).document(user.uid).collection(K.FStore.Questionnaire.collectionName).document(questionnaire?.id ?? "-1")
            
            dbRef.getDocument {[self] (document, error) in
                guard let document = document, document.exists else { return print("Document does not exist") }
                
                document.reference.collection(K.FStore.Questionnaire.childCollectionName).getDocuments {(querySnapshot, error) in
                    guard error == nil else { return print("Error getting documents") }
                    guard let snapshotDocuments = querySnapshot?.documents else { return print("No documents") }
                    
                    questionnaire?.questions = snapshotDocuments.compactMap { (queryDocumentSnapshot) -> Question? in
                        return try? queryDocumentSnapshot.data(as: Question.self)
                    }
                }
            }
        }
    }
    
    func saveResult() {
        if let user = currentUser, let questionnaire = questionnaire {
            
            db.collection(K.FStore.Student.collectionName).document(currentUser?.uid ?? "0").updateData([
                K.FStore.Student.questionnaires: [ questionnaire.id: questionsAnswered ]
            ]) { error in
                guard error == nil else { return ProgressHUD.showFailed("Error saving user result") }
            }
            
            let dbRef = db.collection(K.FStore.Student.collectionName).document(user.uid).collection(K.FStore.Questionnaire.collectionName).document(questionnaire.id)
            
            dbRef.setData([
                K.FStore.Questionnaire.description: questionnaire.description,
                K.FStore.Questionnaire.createdBy: questionnaire.createdBy,
                K.FStore.Questionnaire.title: questionnaire.title,
                K.FStore.Questionnaire.result: ""
            ]) { error in
                guard error == nil else { return print("Error getting documents") }
                
                for question in questionnaire.questions {
                    do {
                        let _ = try dbRef.collection(K.FStore.Questionnaire.childCollectionName).document(question.id ?? "-1").setData(from: question)
                        print("Document successfully written!")
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
}
