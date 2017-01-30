//
//  TriviaQuestionModel.swift
//  TrueFalseStarter
//
//  Created by Annika Noren on 1/27/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation
import GameKit

struct TriviaQuestionModel{
    
    let trivia: [[String : String]] = [
        ["Question": "Can only female koalas can whistle?", "Answer": "False"],
        ["Question": "Are blue whales are technically whales", "Answer": "True"],
        ["Question": "Are camels cannibalistic?", "Answer": "False"],
        ["Question": "Are all ducks birds?", "Answer": "True"],
        ["Question": "Is Sweden a NATO member?", "Answer": "False"]
    ]
    
    let questions: [Question] = [
        Question(question: "In terms of land, which state is Sweden closest to in size?", options: ["TX", "CA","FL", "MT"], answer: 1),
        Question(question: "Which singing group is NOT from Sweden?", options: ["ABBA", "Ace of Base", "The Cranberries", "The Cardigans"], answer: 2),
        Question(question: "What is the Swedish population (approx)?", options: ["5 million", "10 million", "15 million"], answer: 1),
        Question(question: "What are the Swedish flag colors?", options: ["red/yellow", "red/white", "blue/white", "blue/yellow"], answer: 3),
        Question(question: "Which invention is NOT from Sweden?", options: ["pacemaker", "ultrasound", "3-point seatbelt", "cheese slicer"], answer: 3),
        Question(question: "Approxiamately, what % of Swedes speak English?", options: ["66%", "86%", "91%"], answer: 1)
    ]

}

struct Question{
    let question: String
    let options: [String]
    let answer: Int
}
