//
//  MainCVController.swift
//  GetFrench
//
//  Created by Vladyslav PALAMARCHUK on 1/27/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class MainCVController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var images: [ImagesDB] = []
    
    lazy var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = #colorLiteral(red: 0.9175567031, green: 0.9177106619, blue: 0.9261446595, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.9175744653, green: 0.9176921248, blue: 0.9261391163, alpha: 1)
        getImagesFromDB()
    }
    
    func getImagesFromDB() {
           
           let fetchImage: NSFetchRequest<ImagesDB> = ImagesDB.fetchRequest()
           let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
           fetchImage.sortDescriptors = [sortDescriptor]
           
           do {
               let imagesObj = try context?.fetch(fetchImage)
               for imageObj in imagesObj! {
                   
                   if let context = context, let imageData = imageObj.image, let image = UIImage(data: imageData) {
                       let newImageDB = ImagesDB(context: context)
                       newImageDB.image = image.pngData()
                       newImageDB.id = imageObj.id
                       newImageDB.title = imageObj.title
                       images.append(newImageDB)
                   }
               }
           } catch {
               print("Error. Fail to fetch images from DB.\n", error)
           }
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = "Categories"
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTwoTypesVC" {
            guard let dvc = segue.destination as? TwoTypesVC,
                let indexPath = sender as? IndexPath else { return }
            
            dvc.words = themeModel[indexPath.row].words
            dvc.titleStr = themeModel[indexPath.row].title
            dvc.row = indexPath.row
        }
    }


}

extension MainCVController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCVCell", for: indexPath) as? MainCVCell,
                let title = themeModel[indexPath.row].title else { return UICollectionViewCell() }
            
//            cell.selectionStyle = .none
            cell.titleLabel.text = title
            
            if let image = UIImage(named: "defaultImage") {
                cell.photoImageView.image = image
            }
            
//            cell.bgView.backgroundColor = bgColors[indexPath.row % 5]
            
            // Try to get image from DB
            if let index = images.firstIndex(where: { $0.id == Int16(indexPath.row) }),
                let imageData = images[index].image {
//                print("get image from DB, row -", indexPath.row)
                cell.photoImageView.image = UIImage(data: imageData)
            } else {
                // Get Image From URL
                if let index = imageModel.firstIndex(where: {$0.title == title}),
                    let url = URL(string: imageModel[index].img_url ?? ""),
                    let context = self.context {
                    
                    URLSession.shared.dataTask(with: url) { (data, _, error) in
                        guard error == nil else { return print(error!)}
                        guard let data = data,
                            let image = UIImage(data: data)
                            else { return print("no data")}
                        
                        let newImageInDB = ImagesDB(context: context)
                        newImageInDB.id = Int16(indexPath.row)
                        newImageInDB.title = imageModel[index].title
                        newImageInDB.image = data
                        do {
                            try self.context?.save()
                            self.images.append(newImageInDB)
                        } catch {
                            print("Error save image to DB\n", error)
                        }
                        
                        DispatchQueue.main.async {
                            cell.photoImageView.image = image
//                            print("get image from URL, row -", indexPath.row)
                        }
                    }.resume()
                }
            }

            return cell
        }
}

extension MainCVController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        animateTap(cell) {
            self.performSegue(withIdentifier: "segueToTwoTypesVC", sender: indexPath)
        }
    }
    
}

extension MainCVController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = self.view.bounds.width / 2 - 30
        return CGSize(width: size, height: size)
    }
}
