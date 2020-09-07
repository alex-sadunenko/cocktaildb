//
//  DrinkTableViewCell.swift
//  CocktailDB
//
//  Created by Alex on 07.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        
        didSet {
            nameLabel.textColor = UIColor(red: 0.496, green: 0.496, blue: 0.496, alpha: 1)
            nameLabel.font = UIFont(name: "Roboto-Regular", size: 16)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
