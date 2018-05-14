//
//  ProductTableCell.swift
//  FirebaseProject
//
//  Created by Sathiyan Sivaprakasam on 07/04/18.
//  Copyright © 2018 Sathiyan Sivaprakasam. All rights reserved.
//

import UIKit

class ProductTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItemDetails(item : ProductItemModel){
        
        nameLabel.text = "Name : \(item.productName)"
        vendorLabel.text = "Vendor : \(item.productVendor)"
        brandLabel.text  = "Brand : \(item.productBrand)"
        descriptionLabel.text  = "Description : \(item.productDescription)"
    }

}
