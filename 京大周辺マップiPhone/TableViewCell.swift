//
//  TableViewCell.swift
//  京大周辺マップiPhone
//
//  Created by 丸谷 浩永 on 8/28/16.
//  Copyright © 2016 丸谷 浩永. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var basicInformation : RestaurantBasic? = nil {
        didSet {
            let nameLabel = self.viewWithTag(1) as! UILabel
            nameLabel.text = basicInformation?.name
            let genreLabel = self.viewWithTag(3) as! UILabel
            genreLabel.text = basicInformation?.genre
            let favoriteLabel = self.viewWithTag(5) as! UILabel
            if basicInformation!.favorite!.boolValue {
                favoriteLabel.text = "★"
            }else {
                favoriteLabel.text = "☆"
            }
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
