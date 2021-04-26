//
//  StartViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/23/21.
//

import UIKit

class QuestionHomeViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    
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
            // Save Data
            let controllers = self.navigationController?.viewControllers
            for vc in controllers! {
                if vc is QuestionnaireViewController {
                    self.navigationController?.popToViewController(vc as! QuestionnaireViewController, animated: true)
                }
            }
        }
    }
}
