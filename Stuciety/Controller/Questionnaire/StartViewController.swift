//
//  StartViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/23/21.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    var questionnaire: Questionnaire?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor(named: K.BrandColors.purple)
        
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
            descriptionLabel.text = questionnaire.description
        }
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.QuestionnaireCollection.Segue.question, sender: self)
    }
}
