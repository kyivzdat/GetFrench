//
//  ListOfWordsTVCell.swift
//  SpeakGerman
//
//  Created by Vladyslav PALAMARCHUK on 1/23/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import UIKit

class ListOfWordsTVCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var germanLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var delegate: ListOfWordsTVCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        bgView.layer.cornerRadius = 3
        
        bgView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        bgView.layer.shadowRadius = 2
        bgView.layer.shadowOpacity = 0.4
    }
    
    @IBAction func tapLikeButton(_ sender: UIButton) {
        delegate?.tapButton(sender.tag)
    }

}

protocol ListOfWordsTVCellDelegate {
    func tapButton(_ tag: Int)
}
