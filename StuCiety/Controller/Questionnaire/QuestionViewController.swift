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
    @IBOutlet weak var answerTextView: UITextView! {
        didSet {
            answerTextView.delegate = self
        }
    }
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var questionnaire: Questionnaire?
    private var questionCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Questions"
        
        setSwipeGesture()
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Questionnaire.Segue.finish {
            if let destinationVC = segue.destination as? QuestionHomeViewController {
                destinationVC.questionnaire = questionnaire
                destinationVC.questionsAnswered = true
            }
        }
    }
    
    private func setSwipeGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(previousQuestion(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(nextQuestion(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    private func updateUI() {
        guard let questionnaire = questionnaire else { return }
        questionNumberLabel.text = "\(questionCount + 1) of \(questionnaire.questions.count)"
        questionLabel.text = questionnaire.questions[questionCount].text
        answerTextView.text = questionnaire.questions[questionCount].answer
        
        backButton.isHidden = questionCount == 0 ? true : false
    }
}

//MARK: - Button Events

extension QuestionViewController {
    
    @IBAction func previousQuestion(_ sender: UIButton) {
        questionCount -= 1
        updateUI()
    }
    
    @IBAction func nextQuestion(_ sender: UIButton) {
        answerTextView.endEditing(true)
        questionCount += 1
        if questionCount < (questionnaire?.questions.count) ?? 0 {
            updateUI()
        } else {
            performSegue(withIdentifier: K.Questionnaire.Segue.finish, sender: self)
        }
    }
}

//MARK: - UITextViewDelegate

extension QuestionViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if questionCount < (questionnaire?.questions.count) ?? 0 {
            questionnaire?.questions[questionCount].answer = textView.text ?? ""
        }
    }
}
