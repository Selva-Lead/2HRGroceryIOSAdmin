//
//  Order_Lookup_CellTableViewCell.swift
//  2HrGrocery
//
//  Created by Sathiyan Sivaprakasam on 10/04/18.
//  Copyright © 2018 Sathiyan Sivaprakasam. All rights reserved.
//

import UIKit

class Order_Lookup_Cell: UITableViewCell {

    @IBOutlet weak var order_id: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var totallbl: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var deliveryBy: UILabel!
    @IBOutlet weak var status: UIButton!
    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
