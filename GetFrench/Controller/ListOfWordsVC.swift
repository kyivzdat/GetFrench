//
//  ListOfWordsVC.swift
//  SpeakGerman
//
//  Created by Vladyslav PALAMARCHUK on 1/23/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ListOfWordsVC: UIViewController {

    var words: [Words]!
    var row: Int!
    var titleStr: String!
    
    lazy var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView(tableView)
//        addBlurEffect(bgImageView, blurEffect: UIBlurEffect(style: .dark))
    }
    
    func setupTableView(_ tableView: UITableView) {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = titleStr
        tableView.reloadData()
    }
}

extension ListOfWordsVC: UITableViewDataSource {
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListOfWordsTVCell,
            let likeImage = UIImage(named: "like"),
            let dislikeImage = UIImage(named: "dislike") else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.delegate = self
        cell.likeButton.tag = indexPath.row
        
        // Image
        if isSelectedWordsContain(row: row, id: indexPath.row).0 {
            cell.likeButton.setImage(likeImage, for: .normal)
        } else {
            cell.likeButton.setImage(dislikeImage, for: .normal)
        }
        
        cell.englishLabel.text = words[indexPath.row].english
        cell.germanLabel.text = words[indexPath.row].french
        
        return cell
    }
    
}

extension ListOfWordsVC: UITableViewDelegate {
    
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        animateTap(cell) {}
        tableView.deselectRow(at: indexPath, animated: true)
        guard let word = words[indexPath.row].french else { return print("bad word") }
        speakWord(word)
        
    }
}

extension ListOfWordsVC: ListOfWordsTVCellDelegate {
    
    func tapButton(_ tag: Int) {
        
        print("tap like")
        let indexPath = IndexPath(row: tag, section: 0)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ListOfWordsTVCell,
            let likeImage = UIImage(named: "like"),
            let dislike = UIImage(named: "dislike"),
            let context = context else { return print("Error. tapButton") }
        animateTap(cell.likeButton) {}
        let isContain = isSelectedWordsContain(row: row, id: tag)
        
        if isContain.0 {
            
            let fetchRequest: NSFetchRequest<LikedWordsDB> = LikedWordsDB.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "row == %i AND id == %i", row, tag)
            do {
                let test = try context.fetch(fetchRequest)
                guard let objToDelete: NSManagedObject = test.first else { return }
                
                context.delete(objToDelete)
                
                try context.save()
                cell.likeButton.setImage(dislike, for: .normal)
                print("Delete word -", words?[Int(likedWords[isContain.1].id)].english ?? "", words?[Int(likedWords[isContain.1].id)].french ?? "nil")
                print("\t", words[tag])
                likedWords.remove(at: isContain.1)
                
            } catch {
                print("Error delete word\n", error)
            }
            
        } else {
            
            let newSelectedWord = LikedWordsDB(context: context)

            newSelectedWord.row = Int16(row)
            newSelectedWord.id = Int16(tag)
            
            do {
                try context.save()
                likedWords.append(newSelectedWord)
                print("Save new word -", words[tag].english ?? "", words[tag].french ?? "")
                cell.likeButton.setImage(likeImage, for: .normal)
            } catch {
                print("Error save new word\n", error)
            }
        }
        
    }
}
