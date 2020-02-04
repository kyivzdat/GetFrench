//
//  LikedWordsVC.swift
//  SpeakGerman
//
//  Created by Vladyslav PALAMARCHUK on 1/23/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import CoreData

class LikedWordsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyListImageView: UIImageView!
    
    var isNeedsToReload: Bool = false
    
    lazy var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addBlurEffect(view, blurEffect: UIBlurEffect(style: .dark))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = "Marked words"
        print("isNeedsToReload -", isNeedsToReload)

        emptyListImageView.isHidden = (likedWords.isEmpty) ? false : true
        
        if isNeedsToReload {
            print("isNeedsToReload")
            isNeedsToReload = false
            tableView.reloadData()
        }
    }
}

extension LikedWordsVC: UITableViewDataSource {
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return likedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "likedCell", for: indexPath) as? ListOfWordsTVCell,
            let likeImage = UIImage(named: "like"),
            let dislikeImage = UIImage(named: "dislike") else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.delegate = self
        cell.likeButton.tag = indexPath.row
        
        cell.backgroundColor = .clear
        
        let coord = likedWords[indexPath.row]
        let row = Int(coord.row)
        let id = Int(coord.id)
        
        // Image
        if isSelectedWordsContain(row: row, id: id).0 {
            cell.likeButton.setImage(likeImage, for: .normal)
        } else {
            cell.likeButton.setImage(dislikeImage, for: .normal)
        }
        
        if let word = themeModel[row].words?[id] {
            cell.englishLabel.text = word.english
            cell.germanLabel.text = word.french
        }
        
        return cell
    }
}

extension LikedWordsVC: UITableViewDelegate {
    
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        animateTap(cell) {}
        
        let coord = likedWords[indexPath.row]
        let row = Int(coord.row)
        let id = Int(coord.id)

        tableView.deselectRow(at: indexPath, animated: true)

        if let word = themeModel[row].words?[id], let german = word.french {
            speakWord(german)
        }
        
    }
}

extension LikedWordsVC: ListOfWordsTVCellDelegate {
    
    func tapButton(_ tag: Int) {
        
        let indexPath = IndexPath(row: tag, section: 0)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ListOfWordsTVCell,
            let likeImage = UIImage(named: "like"),
            let dislikeImage = UIImage(named: "dislike"),
            let context = context else { return }
        
        animateTap(cell.likeButton) {}
        
        let coord = likedWords[indexPath.row]
        let row = Int(coord.row)
        let id = Int(coord.id)

        
        let isContain = isSelectedWordsContain(row: row, id: id)
        
        if isContain.0 {
            
            let fetchRequest: NSFetchRequest<LikedWordsDB> = LikedWordsDB.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "row == %i AND id == %i", row, id)
            do {
                let test = try context.fetch(fetchRequest)
                guard let objToDelete: NSManagedObject = test.first else { return }
                
                context.delete(objToDelete)
                try context.save()
                cell.likeButton.setImage(dislikeImage, for: .normal)
                
                likedWords.remove(at: isContain.1)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                emptyListImageView.isHidden = (likedWords.isEmpty) ? false : true
            } catch {
                print("Error delete word")
            }
            
            
        } else {
            
            let newLikedWord = LikedWordsDB(context: context)
            newLikedWord.row = Int16(row)
            newLikedWord.id = Int16(id)
            
            do {
                try context.save()
                likedWords.append(newLikedWord)
                cell.likeButton.setImage(likeImage, for: .normal)
            } catch {
                print("Error save new word\n", error)
            }
        }
        
    }
    
    
}
