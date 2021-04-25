//
//  QuestionViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/24/21.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var questionCount = 0
    var questionnaire: Questionnaire?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        answerTextField.delegate = self
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.QuestionnaireCollection.Segue.finish {
            if let destinationVC = segue.destination as? QuestionHomeViewController {
                destinationVC.questionnaire = questionnaire
                destinationVC.complete = true
            }
        }
    }
    
    func updateUI() {
        if let questionnaire = questionnaire {
            questionNumberLabel.text = "\(questionCount + 1) of \(questionnaire.question.count)"
            questionLabel.text = questionnaire.question[questionCount].text
            answerTextField.text = questionnaire.question[questionCount].answer
            
            backButton.isHidden = questionCount == 0 ? true : false
        }
    }
    
    @IBAction func previousQuestion(_ sender: UIButton) {
        questionCount -= 1        
        updateUI()
    }
    
    @IBAction func nextQuestion(_ sender: UIButton) {
        questionCount += 1
        if questionCount < (questionnaire?.question.count)! {
            updateUI()
        } else {
            self.performSegue(withIdentifier: K.QuestionnaireCollection.Segue.finish, sender: self)
        }
    }
}

//MARK: - UITextViewDelegate

extension QuestionViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        questionnaire?.question[questionCount].answer = textField.text ?? ""
    }
}
