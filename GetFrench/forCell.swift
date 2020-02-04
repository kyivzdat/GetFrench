//
//  forCell.swift
//  LearnSpanish
//
//  Created by Vladyslav PALAMARCHUK on 1/26/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

func isSelectedWordsContain(row: Int, id: Int) -> (Bool, Int) {
    var isContain = false
    
    var returnIndex = 0
    for (index, coord) in likedWords.enumerated() {
        returnIndex = index
        if coord.row == row && coord.id == id {
            isContain = true
            break
        }
    }
    return (isContain, returnIndex)
}

func speakWord(_ word: String) {
    let utterance = AVSpeechUtterance(string: word)
    utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
    utterance.rate = 0.4
    
    let synthesizer = AVSpeechSynthesizer()
    synthesizer.speak(utterance)
    print("Speak", word)
}
