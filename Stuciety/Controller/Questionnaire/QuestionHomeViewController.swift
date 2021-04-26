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
    
    let db = Firestore.firestore()
    var currentUser: User? = Auth.auth().currentUser
    
    var questionnaire: Questionnaire?
    var complete: Bool = false
    var completionText = "Thank you for your time filling in the questionnaire, we will update your result and notify the counselor."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = !complete ? "Start" : "Finish"
        self.navigationItem.setHidesBackButton(complete, animated: true)
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.QuestionnaireCollection.Segue.question {
            if let destinationVC = segue.destination as? QuestionViewController {
                destinationVC.questionnaire = questionnaire
            }
        }
    }
    
    func updateUI() {
        if let questionnaire = questionnaire {
            descriptionLabel.text = !complete ? questionnaire.description : completionText
            buttonLabel.setTitle(!complete ? "Start" : "Complete", for: .normal)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if !complete {
            self.performSegue(withIdentifier: K.QuestionnaireCollection.Segue.question, sender: self)
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
    
    func saveResult() {
        if let user = currentUser, let questionnaire = questionnaire {
            
            let dbRef = db.collection(K.FStore.Student.collectionName).document(user.uid).collection(questionnaire.id)
            
            for question in questionnaire.question {
                dbRef.document(question.no).setData([
                    K.FStore.Questionnaire.Child.text: question.text,
                    K.FStore.Questionnaire.Child.answer: question.answer
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            }
        }
    }
}
