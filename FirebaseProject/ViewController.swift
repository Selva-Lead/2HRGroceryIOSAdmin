//
//  ViewController.swift
//  FirebaseProject
//
//  Created by Sathiyan Sivaprakasam on 07/04/18.
//  Copyright © 2018 Sathiyan Sivaprakasam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    
    var ref  : DatabaseReference!
    var productList = [ProductItemModel]()
    
    @IBOutlet weak var productTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        productTable.delegate   = self
        productTable.dataSource = self
        
        getProductItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func getProductItems() {
        
        ref = Database.database().reference().child("productsForSale");
        
        //observing the data changes
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.productList.removeAll()
                
                //iterating through all the values
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    if let itemObject = artists.value as? [String: AnyObject] {
                       
                        let productName   = itemObject["name"]  as? String ?? ""
                        let productBrand  = itemObject["brand"] as? String ?? ""
                        let productvendor  = itemObject["vendor"] as? String ?? ""
                        let productdescription  = itemObject["description"] as? String ?? ""
                       
                        //creating artist object with model and fetched values
                        let item = ProductItemModel(productName: productName, productBrand: productBrand, productVendor: productvendor, productDescription: productdescription)
                        
                        self.productList.append(item)
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                    //reloading the tableview
                    self.productTable.reloadData()
                    
                }
              
               
            }
        })
        
        
    }
    
    
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return productList.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productcell", for: indexPath) as! ProductTableCell
        
        cell.setItemDetails(item: productList[indexPath.row])
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}



