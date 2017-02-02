//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    //variables and constants
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    //array to hold the index of questions already used
    var usedIndexes = [Int]()
    
    //variables for sounds
    var gameSound: SystemSoundID = 0
    var rightSound: SystemSoundID = 0
    var wrongSound: SystemSoundID = 0
    
    //create an instance of the TriviaQuestionModel
    let triviaQuestionModel = TriviaQuestionModel()
    
    //setting up timer
    var timer = Timer()
    var timerCounter = 0
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!    
    @IBOutlet weak var Answer3Button: UIButton!
    @IBOutlet weak var Answer4Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameSounds()
        
        // Start game
        playGameStartSound()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        messageLabel.text = ""
        messageLabel.textColor = UIColor.orange
        
        //start the timer
        startTimer()
        
        //get random number
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: triviaQuestionModel.questions.count)
        
        
        //test to see if random has already been used, get another random until an unused one is found
        while usedIndexes.contains(indexOfSelectedQuestion) {
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: triviaQuestionModel.questions.count)
        }
        
        //add the used random to the index
        usedIndexes.append(indexOfSelectedQuestion)
        
        //display the question
        let question = triviaQuestionModel.questions[indexOfSelectedQuestion]
        questionField.text = question.question
        
        //display the answer options
        let buttons = [trueButton, falseButton, Answer3Button, Answer4Button]
        
        for i in 0..<question.options.count{
            buttons[i]?.setTitle(question.options[i], for: .normal)
            buttons[i]?.isHidden = false
        }
        
        for i in question.options.count..<buttons.count{
            buttons[i]?.isHidden = true
        }
        

        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        trueButton.isHidden = true
        falseButton.isHidden = true
        Answer3Button.isHidden = true
        Answer4Button.isHidden = true
        messageLabel.text = ""
        
        // Display play again button
        playAgainButton.isHidden = false
        
        //turn off timer
        timer.invalidate()
        
        //Display results
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        //determine the correct answer from the struct
        let selectedQuestionDictionary = triviaQuestionModel.questions[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDictionary.answer
        
        //the button pushed is the sender with it's assigned tag
        let selectedAnswer = sender.tag
        
        //turn off timer
        timer.invalidate()
        
        //check answer
        if selectedAnswer == correctAnswer {
            correctQuestions += 1
            messageLabel.textColor = UIColor.green
            messageLabel.text = "Correct!"
            playRightAnswerSound()
        } else {
            messageLabel.textColor = UIColor.red
            messageLabel.text = "Sorry, wrong answer!"
            playWrongAnswerSound()
        }
        
        //loop through the buttons to make the wrong answers gray
        let buttons = [trueButton, falseButton, Answer3Button, Answer4Button]
        
        for i in 0..<buttons.count {
            if i != correctAnswer {
                buttons[i]?.setTitleColor(UIColor.gray, for: .normal)
            }
        }
        
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
            
        } else {
            //re-set buttons to normal color
            let buttons = [trueButton, falseButton, Answer3Button, Answer4Button]
            
            for i in 0..<buttons.count {
                    buttons[i]?.setTitleColor(UIColor.white, for: .normal)
                
            }
            
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        trueButton.isHidden = false
        falseButton.isHidden = false
        Answer3Button.isHidden = false
        Answer4Button.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        usedIndexes = []
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameSounds() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let pathToSoundFile2 = Bundle.main.path(forResource: "RightSound", ofType:"wav")
        let pathToSoundFile3 = Bundle.main.path(forResource: "WrongSound", ofType:"wav")
        
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        let soundURL2 = URL(fileURLWithPath: pathToSoundFile2!)
        let soundURL3 = URL(fileURLWithPath: pathToSoundFile3!)
        
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
        AudioServicesCreateSystemSoundID(soundURL2 as CFURL, &rightSound)
        AudioServicesCreateSystemSoundID(soundURL3 as CFURL, &wrongSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func playRightAnswerSound() {
        AudioServicesPlaySystemSound(rightSound)
    }

    func playWrongAnswerSound() {
        AudioServicesPlaySystemSound(wrongSound)
    }
    
    func startTimer(){
        timerCounter = 0
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
        
    func timerAction() {
            timerCounter += 1
            messageLabel.text = "\(timerCounter)"
    }
    
}

