//
//  ViewController.swift
//  LearnerCardsWithModel
//
//  Created by Chirag Dodia on 3/12/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    
    var questionDisplayed = false
    let myLearnerCardModel = LearnerCardModel()

    @IBAction func showQuestion(_ sender: Any) {
        let lQuestion: String = self.myLearnerCardModel.getNextQuestion()
        self.questionLabel.text = lQuestion

        // Clear the answer label when a new question is shown
        self.answerLabel.text = ""
        questionDisplayed = true
    }
    
    @IBAction func showAnswer(_ sender: Any) {
        if questionDisplayed {
            self.answerLabel.text = self.myLearnerCardModel.getAnswer()
        } else {
            self.answerLabel.text = "Please ask a question first!"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
