//
//  GameVC.swift
//  SpeakGerman
//
//  Created by Vladyslav PALAMARCHUK on 1/23/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
    
    var words: [Words]!
    var originalWords: [Words] = []
    var titleStr: String!
    
    @IBOutlet weak var englishTextLabel: UILabel!
    @IBOutlet weak var bgTextView: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var answerButtons: Array<UIButton>!
    
    @IBOutlet weak var summaLabel: UILabel!
    @IBOutlet weak var currentNumberLabel: UILabel!
    
    var answerArray: [String] = []
    var answer: String = ""
    var isTapedButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        originalWords = words

        summaLabel.text = "/\(originalWords.count)"
        currentNumberLabel.text = "0"
        
//        addBlurEffect(view, blurEffect: UIBlurEffect(style: .dark))
        setupViews()
        launchWord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = titleStr
    }
    
    func setupViews() {

        answerButtons?.forEach { (button) in
            
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            button.layer.shadowOffset = CGSize(width: 1, height: 1)
            button.layer.shadowRadius = 2
            button.layer.shadowOpacity = 0.4
            
            button.layer.cornerRadius = 3
        }
        
        nextButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        nextButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        nextButton.layer.shadowRadius = 2
        nextButton.layer.shadowOpacity = 0.4
        
        englishTextLabel.layer.cornerRadius = 3
        englishTextLabel.clipsToBounds = true
        bgTextView.backgroundColor = .clear
    }
    
    func launchWord() {
        print("words.count -", words.count)
        answerArray = []
        var randomIndex = Int.random(in: 0..<words.count)
        
        englishTextLabel.text = words[randomIndex].english
        
        guard let germanWord = words[randomIndex].french else { return }
        answer = germanWord
        
        answerArray.append(germanWord)
        
        while answerArray.count < 4 {
            randomIndex = Int.random(in: 0..<originalWords.count)
            guard let german = originalWords[randomIndex].french else { continue }
            let newWord = german
            if !answerArray.contains(newWord) {
                answerArray.append(newWord)
            }
        }
    
        answerArray.shuffle()
        
        while answerArray.count < 4 {
            answerArray.append(" ")
        }
        
        for (index, button) in answerButtons.enumerated() {
            button.setTitle(answerArray[index], for: .normal)
        }
    }
    
    @IBAction func tapAnswerButton(_ sender: UIButton) {
        
        let button: UIButton!
        var buttons: [UIButton] = answerButtons ?? []
        
        switch sender.tag {
        case 0:
            button = answerButtons[0]
            buttons.remove(at: 0)
        case 1:
            button = answerButtons[1]
            buttons.remove(at: 1)
        case 2:
            button = answerButtons[2]
            buttons.remove(at: 2)
        case 3:
            button = answerButtons[3]
            buttons.remove(at: 3)
        default:
            return
        }
        
        self.checkAnswer(button, anotherButtons: buttons)
        isTapedButton = true
        animateTap(button) {
            
        }
    }
    
    func checkAnswer(_ button: UIButton, anotherButtons: [UIButton]) {
        
        func deleteIfCorrectAnswer(_ answer: String) {
            for (index, word) in words.enumerated() {
                if word.french == answer {
                    words.remove(at: index)
                    break
                }
            }
        }
        guard button.titleLabel?.text != " " else { return }

        if button.titleLabel?.text == answer {
            button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            
            if isTapedButton == false {
                deleteIfCorrectAnswer(answer)
                currentNumberLabel.text = String(originalWords.count - words.count)
            }
        } else {
            button.backgroundColor = #colorLiteral(red: 1, green: 0.03549327701, blue: 0.1480868757, alpha: 1)
            anotherButtons.forEach { (button) in
                if button.titleLabel?.text == answer {
                    button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                }
            }
        }
        
        if words.count == 0 {
            endedWords()
        }
    }
    
    func endedWords() {
        let ac = UIAlertController(title: "Congratulations!", message: "You have named all word in this theme!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.performSegue(withIdentifier: "unwindToTwoTypesVC", sender: nil)
        }
        let againButton = UIAlertAction(title: "Try again", style: .default) { (_) in
            self.words = self.originalWords
            self.currentNumberLabel.text = "0"
            self.launchWord()
        }
        ac.addAction(okButton)
        ac.addAction(againButton)
        present(ac, animated: true)
    }
    
    @IBAction func tappedNext(_ sender: UIButton) {
        isTapedButton = false
        animateTap(nextButton) {}
        answerButtons.forEach { (button) in
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        launchWord()
    }
}
