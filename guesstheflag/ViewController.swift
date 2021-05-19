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
    
    private lazy var countries = [String]()
    private lazy var score = 0
    private lazy var correctAnswer = 0
    private lazy var questionCount = 0
    private lazy var correctFlags = 0
    private lazy var incorrectFlags = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCountries()
        askQuestion(action: nil)
        applyStylingToButtons()
        applyStylingToText()
        setBackground()
    }

    private func loadCountries() {
        countries += ["estonia",
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
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        animateFlagMovement()
        correctAnswer = Int.random(in: 0...2)
        title = "Score: \(score)".uppercased()
        label1.text = countries[correctAnswer].uppercased()
        
        questionCount += 1
        
    }
    
    private func hasGameCompleted() -> Bool{
        return (questionCount >= 10 ? true : false)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        (sender.tag == correctAnswer) ? playSound(true) : playSound(false)
        let title = (sender.tag == correctAnswer) ? "That is CORRECT!" : "INCORRECT!\nYou chose the national flag of \(countries[sender.tag].uppercased())"
        score = score + (sender.tag == correctAnswer ?  1 : -1)
        correctFlags = correctFlags + (sender.tag == correctAnswer ?  1 : 0)
        incorrectFlags = incorrectFlags + (sender.tag == correctAnswer ?  0 : 1)
        hasGameCompleted() ? showGameSummary() : showAlert(title: title)
        questionCount = questionCount >= 10 ? 0: questionCount
        
        
    }
    
    private func showAlert(title: String){
        let alertController = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion(action: )))
        
        present(alertController, animated: true)
        
    }
    
    private func showGameSummary(){
        let alertController = UIAlertController(title: "Game Summary", message: "Your score is \(score)\nYou got \(correctFlags) flags correct\nAnd \(incorrectFlags) flags incorrect", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion(action: )))
        
        present(alertController, animated: true)
        
    }
    
    @IBAction func showGameSummaryOnly(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Game Summary", message: "Your score is \(score)\nYou got \(correctFlags) flags correct\nAnd \(incorrectFlags) flags incorrect", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: doNothing(action: )))
        
        present(alertController, animated: true)
    }
    
    private func playSound(_ answer: Bool){
        let pathToSound = (answer ? (Bundle.main.path(forResource: "correct", ofType: "wav")!) : (Bundle.main.path(forResource: "incorrect", ofType: "wav")!))
        let url = URL(fileURLWithPath: pathToSound)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            //future error handling when the knowledge becomes available
        }
    }
    
    private func doNothing(action: UIAlertAction!){
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        score = 0
        questionCount = 0
        correctFlags = 0
        incorrectFlags = 0
        askQuestion(action: nil )
    }
}

