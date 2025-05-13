//
//  EditCardsViewController.swift
//  TabbedLearnerCards
//
//  Created by Chirag  on 3/30/25.
//

import UIKit

class EditCardsViewController: UIViewController {

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!

    var appDelegate: AppDelegate?
    var myLearnerCardModel: LearnerCardModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myLearnerCardModel = self.appDelegate?.myLearnerCardModel

        self.questionTextField.text = self.myLearnerCardModel?.getCurrentQuestion()
        self.answerTextField.text = self.myLearnerCardModel?.getAnswer()
    }

    @IBAction func buttonOKAction(sender: AnyObject) {
        if let newQ = self.questionTextField.text,
           let newA = self.answerTextField.text {
            self.myLearnerCardModel?.setCurrentQuestion(pString: newQ)
            self.myLearnerCardModel?.setCurrentAnswer(pString: newA)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
