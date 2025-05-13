//
//  LearnerCardViewController.swift
//  TabbedLearnerCards
//
//  Created by Chirag Dodia on 3/12/25.
//

import UIKit

class LearnerCardViewController: UIViewController {

    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    
    var questionDisplayed = false

    // Reference to the AppDelegate
    var appDelegate: AppDelegate?

    // Reference to the shared model
    var myLearnerCardModel: LearnerCardModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.questionLabel.text = "Tap 'Show Question' to start"
        self.answerLabel.text = ""

        // Connect to shared model in AppDelegate
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myLearnerCardModel = self.appDelegate?.myLearnerCardModel

        self.myLearnerCardModel?.currentQuestionIndex = -1
        questionDisplayed = false
    }

    @IBAction func showQuestion(_ sender: Any) {
        guard let question = self.myLearnerCardModel?.getNextQuestion() else { return }
        self.questionLabel.text = question
        self.answerLabel.text = ""
        questionDisplayed = true
    }

    @IBAction func showAnswer(_ sender: Any) {
        if questionDisplayed {
            self.answerLabel.text = self.myLearnerCardModel?.getAnswer()
        } else {
            self.answerLabel.text = "Please ask a question first!"
        }
    }
}
