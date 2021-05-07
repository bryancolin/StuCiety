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
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var questionnaire: Questionnaire?
    var questionCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Questions"
        answerTextView.delegate = self
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
            answerTextView.text = questionnaire.question[questionCount].answer
            
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

extension QuestionViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        questionnaire?.question[questionCount].answer = textView.text ?? ""
    }
}
