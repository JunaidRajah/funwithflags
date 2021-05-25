//
//  FlagLogic.swift
//  guesstheflag
//
//  Created by Junaid Rajah on 2021/05/25.
//

import Foundation

class FlagLogic {
    
    private var countries =
        ["estonia",
          "france",
          "germany",
          "ireland",
          "italy",
          "monaco",
          "nigeria",
          "poland",
          "russia",
          "spain",
          "uk",
          "us"]
    
    private (set) var score = 0
    private lazy var correctAnswer = 0
    private lazy var questionCount = 0
    private (set) var correctFlags = 0
    private (set) var incorrectFlags = 0
    
    init(){
        newQuestion()
        questionCount = 0
    }
    
    func newQuestion() {
        correctAnswer = Int.random(in: 0...2)
        questionCount += 1
        countries.shuffle()
    }
    
    var getCorrectCountryName: String{
        return countries[correctAnswer].uppercased()
    }
    
    var getCorrectCountryPosition: Int{
        correctAnswer
    }
    
    func getCountryAtPosition(index: Int) -> String{
        countries[index]
    }
    
    func isCorrectAnswer(userAnswer: Int) -> Bool {
        let isCorrect = countries[correctAnswer] == countries[userAnswer]
        score += isCorrect ?  1 : -1
        correctFlags = correctFlags + (userAnswer == correctAnswer ?  1 : 0)
        incorrectFlags = incorrectFlags + (userAnswer == correctAnswer ?  0 : 1)
        return isCorrect
    }
    
    func hasGameCompleted() -> Bool{
        let gameComplete =  (questionCount >= 9 ? true : false)
        questionCount = questionCount >= 9 ? 0: questionCount
        return gameComplete
    }
    
    func restartGame() {
        score = 0
        questionCount = 0
        correctFlags = 0
        incorrectFlags = 0
        newQuestion()
    }
}
