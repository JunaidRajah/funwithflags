//
//  ViewController.swift
//  guesstheflag
//
//  Created by Junaid Rajah on 2021/05/19.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet private weak var button1: UIButton!
    @IBOutlet private weak var button2: UIButton!
    @IBOutlet private weak var button3: UIButton!
    @IBOutlet private weak var label1: UILabel!
    @IBOutlet private weak var label2: UILabel!
    
    private var audioPlayer: AVAudioPlayer?
    
    private lazy var flagLogic = FlagLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStylingToButtons()
        applyStylingToText()
        setBackground()
        updateView()
    }
    
    private func setBackground(){
        let background = UIImage(named: "wolf")
        
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    private func updateView(){
        setFlagImages()
        animateFlagMovement()
        setCorrectCountryText()
        setTitle()
    }
    private func setFlagImages() {
        button1.setImage(UIImage(named: flagLogic.getCountryAtPosition(index: 0)), for: .normal)
        button2.setImage(UIImage(named: flagLogic.getCountryAtPosition(index: 1)), for: .normal)
        button3.setImage(UIImage(named: flagLogic.getCountryAtPosition(index: 2)), for: .normal)
    }
    
    private func applyStylingToButtons(){
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func applyStylingToText(){
        label1.font = UIFont(name: "Helvetica-Bold", size: 24.00)
        label2.font = UIFont(name: "Helvetica-Bold", size: 18.00)
    }
    
    private func animateFlagMovement(){
        UIView.animate(withDuration: 1, animations: { [self] in
            self.button1.frame = CGRect(x: -200, y: button1.frame.origin.y, width: button1.frame.size.width, height: button1.frame.size.height)
            self.button2.frame = CGRect(x: 400, y: button2.frame.origin.y, width: button2.frame.size.width, height: button2.frame.size.height)
            self.button3.frame = CGRect(x: -200, y: button3.frame.origin.y, width: button3.frame.size.width, height: button3.frame.size.height)
        })
        
        UIView.animate(withDuration: 1, animations: { [self] in
            self.button1.frame = CGRect(x: button1.frame.origin.x, y: button1.frame.origin.y, width: button1.frame.size.width, height: button1.frame.size.height)
            self.button2.frame = CGRect(x: button2.frame.origin.x, y: button2.frame.origin.y, width: button2.frame.size.width, height: button2.frame.size.height)
            self.button3.frame = CGRect(x: button3.frame.origin.x, y: button3.frame.origin.y, width: button3.frame.size.width, height: button3.frame.size.height)
        })
    }
    
    
    private func askQuestion(action: UIAlertAction!){
        flagLogic.newQuestion()
        updateView()
    }
    
    private func setTitle(){
        title = "Score: \(flagLogic.score)".uppercased()
    }
    
    private func setCorrectCountryText(){
        label1.text = flagLogic.getCountryAtPosition(index: flagLogic.getCorrectCountryPosition).uppercased()
    }
    
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title = ""
        if flagLogic.isCorrectAnswer(userAnswer: sender.tag){
            playSound("correct")
            title = "That is CORRECT!"
        } else {
            playSound("incorrect")
            title = "INCORRECT!\nYou chose the national flag of \(flagLogic.getCountryAtPosition(index: sender.tag))"
        }
        showRelevantAlert(title: title)
    }
    
    private func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: handler))
        
        present(alertController, animated: true)
    }
    
    private func showRelevantAlert(title: String){
        flagLogic.hasGameCompleted() ?
            showAlert(title: "Game Summary",
                     message: "Your score is \(flagLogic.score)\nYou got \(flagLogic.correctFlags) flags correct\nAnd \(flagLogic.incorrectFlags) flags incorrect",
                     handler: askQuestion(action: ))
            
            : showAlert(title: title,
                       message: "Your score is \(flagLogic.score)",
                       handler: askQuestion(action: ))
    }
    
    @IBAction func summaryButtonPressed(_ sender: UIButton) {
        showAlert(title: "Game Summary",
                  message: "Your score is \(flagLogic.score)\nYou got \(flagLogic.correctFlags) flags correct\nAnd \(flagLogic.incorrectFlags) flags incorrect",
                  handler: nil)
    }
    
    private func playSound(_ answer: String){
        let pathToSound = Bundle.main.path(forResource: answer, ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            //future error handling when the knowledge becomes available
        }
    }
    
    @IBAction func restartGameButtonPressed(_ sender: UIButton) {
        flagLogic.restartGame()
        flagLogic.newQuestion()
        updateView()
    }
}

