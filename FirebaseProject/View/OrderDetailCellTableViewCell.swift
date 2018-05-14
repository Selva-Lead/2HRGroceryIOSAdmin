//
//  OrderDetailCellTableViewCell.swift
//  FirebaseProject
//
//  Created by Sathiyan Sivaprakasam on 17/04/18.
//  Copyright © 2018 Sathiyan Sivaprakasam. All rights reserved.
//

import UIKit

class OrderDetailCellTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var productimg: UIImageView!
    
    @IBOutlet weak var checkbtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
