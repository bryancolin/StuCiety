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
    
    var questionCount = 0
    var questionnaire: Questionnaire?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }
    
    func updateUI() {
        if let questionnaire = questionnaire {
            questionNumberLabel.text = "\(questionCount + 1) of \(questionnaire.question.count)"
            questionLabel.text = questionnaire.question[questionCount].text
            answerTextView.text = questionnaire.question[questionCount].answer
            answerTextView.text = ""
        }
    }
    
    @IBAction func previousQuestion(_ sender: UIButton) {
        questionCount -= 1        
        updateUI()
    }
    
    @IBAction func nextQuestion(_ sender: UIButton) {
        questionnaire?.question[questionCount].answer = answerTextView.text
        questionCount += 1
        updateUI()
    }
}
