//
//  PartialItems.swift
//  FirebaseProject
//
//  Created by Mitosis on 04/05/18.
//  Copyright © 2018 Sathiyan Sivaprakasam. All rights reserved.
//

import UIKit

class PartialItems: NSObject {

    var productid : String?
    var productName : String?
    var productQuantity : Int?
    var productPrice : Float?
    var producttimestamp : Int?
    
    
    init(productid : String?, productName : String?,productQuantity : Int?,productPrice : Float?,producttimestamp : Int?)
    {
        self.productid = productid!
        self.productName = productName!
        self.productQuantity = productQuantity!
        self.productPrice  = productPrice!
        self.producttimestamp = producttimestamp!
        
    }
}
