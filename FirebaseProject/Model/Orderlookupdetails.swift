//
//  Orderlookupdetails.swift
//  FirebaseProject
//
//  Created by Mitosis on 09/05/18.
//  Copyright © 2018 Sathiyan Sivaprakasam. All rights reserved.
//

import UIKit

class Orderlookupdetails: NSObject {
    
    var CustomerId : String?
    
    var address : String!
    var city : String!
    var fulladdress : String!
    var state : String!
    var zip : String!
    
    var deliveryendtime : String!
    var deliverystarttime : String!
    
    var deliveryType : String?
    
    var ordernumber : String!
    var total : Int!
    var status : String!
    var time : String!
    
    var productname : String!
    var productID : String!
    var price : Int!
    var quantity : Int!
    var timestamp : Int!
    
    var check : String!
   
    var productvarient: [[String:Any]]  = [[String:Any]]()
    
    override init() {
        super.init()
    }
    /*init(CustomerId : String?, address : String?,city : String?,fulladdress : String?,state : String?,zip : String?,deliveryendtime : String?,deliverystarttime : String?,deliveryType : String?)
    {
        self.CustomerId = CustomerId!
        
        self.address = address!
        self.city = city!
        self.fulladdress = fulladdress!
        self.state  = state!
        self.zip = zip!
        
        self.deliveryendtime = deliveryendtime!
        self.deliverystarttime  = deliverystarttime!
        self.deliveryType = deliveryType!
        
    }*/

}
