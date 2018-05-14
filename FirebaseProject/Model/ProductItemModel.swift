//
//  ProductItemModel.swift
//  FirebaseProject
//
//  Created by Sathiyan Sivaprakasam on 07/04/18.
//  Copyright © 2018 Sathiyan Sivaprakasam. All rights reserved.
//

import Foundation
class ProductItemModel {
    var productName : String = ""
    var productBrand : String = ""
    var productVendor : String = ""
    var productDescription : String = ""
    init() {
    }
    init(productName : String,productBrand : String,productVendor : String,productDescription : String) {
        self.productName = productName
        self.productBrand = productBrand
        self.productVendor      = productVendor
        self.productDescription = productDescription
    }
}
