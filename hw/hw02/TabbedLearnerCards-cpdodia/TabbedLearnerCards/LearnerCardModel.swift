//
//  LearnerCardModel.swift
//  TabbedLearnerCards
//
//  Created by Chirag Dodia  on 3/30/25.
//

import Foundation

class LearnerCardModel {
    // instance variables, initialized right here:
    var currentQuestionIndex = -1
    var questions = [
        "How much is 7+7 ?",
        "In what country is Timbuktu ?",
        "What rotates when you ride a bike ?",
        "What is the boiling point of water in Celsius?",
        "Who painted the Mona Lisa?",
        "What is the chemical symbol for gold?",
        "How many states are there in the United States?",
        "Which planet is known as the Red Planet?"
    ]

    var answers = [
        "14",
        "Mali",
        "Wheels",
        "100°C",
        "Leonardo da Vinci",
        "Au",
        "50",
        "Mars"
    ]


    init() {
        self.currentQuestionIndex = 0
    }

    func getNextQuestion() -> String {
        self.currentQuestionIndex = self.currentQuestionIndex + 1
        if self.currentQuestionIndex >= self.questions.count {
            self.currentQuestionIndex = 0
        }
        return self.questions[self.currentQuestionIndex]
    }

    func getCurrentQuestion() -> String {
        return self.questions[self.currentQuestionIndex]
    }

    func getAnswer() -> String {
        return self.answers[self.currentQuestionIndex]
    }
    
    func setCurrentQuestion(pString: String) {
        self.questions[self.currentQuestionIndex] = pString
    }

    func setCurrentAnswer(pString: String) {
        self.answers[self.currentQuestionIndex] = pString
    }
}
// end of class LearnerCardModel
