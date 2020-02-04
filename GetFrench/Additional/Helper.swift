//
//  Helper.swift
//  SpeakGerman
//
//  Created by Vladyslav PALAMARCHUK on 1/23/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation
import UIKit

func animateTap<T>(_ view: T, completion: @escaping () -> ()) {
    let castView: UIView!
    
    if (view as? UIView) != nil {
        castView = view as? UIView
    } else {
        return
    }
    UIView.animate(withDuration: 0.3, animations: {
        castView.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
    }) { (_) in
        completion()
        UIView.animate(withDuration: 0.3, animations: {
            castView.transform = .identity
        })
    }
}

func addBlurEffect(_ view: UIView, blurEffect: UIVisualEffect?) {
    
    let blurEff = (blurEffect != nil) ? blurEffect! : UIBlurEffect(style: .regular)
    let blurEffectView = UIVisualEffectView(effect: blurEff)
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    view.insertSubview(blurEffectView, at: 1)
}

func outlineLabel(string: String, font: String?, size: Int, mainColor: UIColor?, foregroundColor: UIColor?) -> NSAttributedString {
    
    let strokeColor = (foregroundColor != nil) ? foregroundColor! : UIColor.black
    let foregroundColor = (mainColor != nil) ? mainColor! : UIColor.white
    
    let font = (font == nil) ? "Arial Rounded MT Bold" : font
    
    if let font = UIFont(name: font!, size: CGFloat(size)) {
        let attrString = NSAttributedString(string: string, attributes:
            [NSAttributedString.Key.strokeColor:     strokeColor,
             NSAttributedString.Key.foregroundColor: foregroundColor,
             NSAttributedString.Key.strokeWidth:     -4.0,
             NSAttributedString.Key.font:            font])
        return attrString
    }
    print("Font doesnt found -", font ?? "")
    return NSAttributedString(string: string)
}

func parseJson<Element: Decodable>(_ jsonString: String, type: Element.Type) -> [Element] {

    let data = Data(jsonString.utf8)
    do {
        let json = try JSONDecoder().decode([Element].self, from: data)
        return json
    } catch {
        print("Error parce json\n", error)
    }

    return []
}

func getLatLong(_ latLong: String) -> (latitude: String, longitude: String)? {
    
    for (index, char) in latLong.enumerated() {
        if char == "," {
            let latitude = String(latLong.dropLast(latLong.count - index))
            let longitude = String(latLong.dropFirst(index + 1))
            return (latitude, longitude)
        }
    }
    return nil
}
