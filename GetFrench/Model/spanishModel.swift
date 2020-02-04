//
//  germanModel.swift
//  SpeakGerman
//
//  Created by Vladyslav PALAMARCHUK on 1/23/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import UIKit

struct Theme: Decodable {
    var title: String?
    var words: [Words]?
}

struct Words: Decodable {
    var english: String?
    var french: String?
}

var themeModel = [Theme]()
var imageModel = [Image]()

var likedWords: [LikedWordsDB]! {
    didSet {
       
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window,
            let tabBar = window.rootViewController as? UITabBarController,
            let navi = tabBar.viewControllers?.last as? UINavigationController,
            let dvc = navi.viewControllers.first as? LikedWordsVC else { return print("likedWords didSet - false") }
        
        dvc.isNeedsToReload = true
        print("didSet")
    }
}

struct Image: Decodable {
    var title: String?
    var img_url: String?
}
