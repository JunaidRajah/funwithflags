//
//  guesstheflagTests.swift
//  guesstheflagTests
//
//  Created by Junaid Rajah on 2021/05/26.
//

import XCTest

class guesstheflagTests: XCTestCase {
    
    let flagLogic = FlagLogic()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testQuestionCountIncrementsByOne() throws {
        let currentQuestionCount = flagLogic.getQuestionCount
        flagLogic.newQuestion()
        XCTAssertEqual(currentQuestionCount+1, flagLogic.getQuestionCount)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testValidCountryAtPosition6() throws {
        let actualCountry = try flagLogic.getCountryAtPosition(index: 6)
        let noOutput = ""
        XCTAssertNotEqual(actualCountry, noOutput)
    }
    
    func testValidCountryAtNegativePosition() throws {
        do {
            let _ = try flagLogic.getCountryAtPosition(index: -5)
            XCTFail()
        } catch {
        }
    }
    
    func testValidCountryOutOfRange() throws {
        do {
            let _ = try flagLogic.getCountryAtPosition(index: 1000)
            XCTFail()
        } catch {
        }
    }
    
    func testGetCorrectCountryIsValid() {
        let correctCountry = flagLogic.getCorrectCountryName
        let noOutput = ""
        XCTAssertNotEqual(correctCountry, noOutput)
    }
    
    func testCorrectAnswerIncrementsScoreBy1() {
        let currentScore = flagLogic.score
        let _ = flagLogic.isCorrectAnswer(userAnswer: flagLogic.getCorrectCountryPosition)
        XCTAssertEqual(flagLogic.score, currentScore + 1)
    }
    
    func testIfIncorrectAnswerDecrementsScoreBy1() {
        let currentScore = flagLogic.score
        let _ = flagLogic.isCorrectAnswer(userAnswer: (flagLogic.getCorrectCountryPosition + 1) % 3 )
        XCTAssertEqual(flagLogic.score, currentScore - 1)
    }
    
    func testRestartGameMethodScoreReset() {
        flagLogic.restartGame()
        XCTAssertEqual(flagLogic.score, 0)
    }
    
    func testRestartGameMethodCorrectScoreReset() {
        flagLogic.restartGame()
        XCTAssertEqual(flagLogic.correctFlags, 0)
    }
    
    func testRestartGameMethodIncorrectScoreReset() {
        flagLogic.restartGame()
        XCTAssertEqual(flagLogic.incorrectFlags, 0)
    }
    
    func testRestartGameMethodCountReset() {
        flagLogic.restartGame()
        XCTAssertEqual(flagLogic.getQuestionCount, 1)
        //The 1 is due to newQuestion function being called at the end of the restartGame function
    }
    
    

    

}
