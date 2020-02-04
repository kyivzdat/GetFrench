//
//  TwoTypesVC.swift
//  SpeakGerman
//
//  Created by Vladyslav PALAMARCHUK on 1/23/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class TwoTypesVC: UIViewController {

    var words: [Words]!
    var titleStr: String!
    var row: Int!

    @IBOutlet weak var learnButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    @IBOutlet var bgButtonsViews: Array<UIView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        addBlurEffect(view, blurEffect: UIBlurEffect(style: .dark))
        
        setupButtonsViews()
    }
    
    func setupButtonsViews() {
        bgButtonsViews.forEach { (view) in
            view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            view.layer.cornerRadius = 3
//            view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            view.layer.shadowOffset = CGSize(width: 1, height: 1)
            view.layer.shadowRadius = 2
            view.layer.shadowOpacity = 0.4
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = "Select mode"
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        
        let identifier: String!
        let view: UIView!
        
        switch sender.tag {
        case 0:
            identifier = "segueToGameVC"
            view = bgButtonsViews.first
        case 1:
            identifier = "segueToListOfWordsVC"
            view = bgButtonsViews.last
        default:
            return
        }
        animateTap(view) {
            self.performSegue(withIdentifier: identifier, sender: nil)
        }
    }
    
//    MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToListOfWordsVC" {
            guard let dvc = segue.destination as? ListOfWordsVC else { return }
            dvc.words = words
            dvc.row = row
            dvc.titleStr = titleStr
        } else if segue.identifier == "segueToGameVC" {
            guard let dvc = segue.destination as? GameVC else { return }
            dvc.words = words
            dvc.titleStr = titleStr
        }
    }
    
    @IBAction func unwindToTwoTypesVC(_ unwindSegue: UIStoryboardSegue) {
    }
}
