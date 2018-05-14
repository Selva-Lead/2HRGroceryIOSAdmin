//
//  OrderLookup.swift
//  2HrGrocery
//
//  Created by Sathiyan Sivaprakasam on 10/04/18.
//  Copyright © 2018 Sathiyan Sivaprakasam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct orderDetailsStruct {
    static var address: AnyObject=NSNull.self
    static var datetime: AnyObject=NSNull.self
    static var order: AnyObject=NSNull.self
    static var products: NSArray=[]
}

class OrderLookup: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var names=["Order ID: A123BC","Order ID: B123BC","Order ID: C123BC","Order ID: D123BC","Order ID: E123BC"]
    let cellReuseIdentifier = "order_lookup"
    
    var dbref  : DatabaseReference!
    var products = [ProductItemModel]()
    
    var addressarray = [Orderlookupdetails]()
    var orderdataarray = [Orderlookupdetails]()
    var productarray = [Orderlookupdetails]()
    var proVarientarray = [Orderlookupdetails]()
    
   // var productkey = NSMutableArray()
    var dataarray = NSMutableArray()
    //var addressarray = NSMutableArray()
    //var fdataarray = NSMutableArray()
    var searcharray = [Orderlookupdetails]()
    var filtetAddressarray = [Orderlookupdetails]()
    var filtetProductarray = [Orderlookupdetails]()
    
    var appDelegate = AppDelegate()
    
    var addressDic:Dictionary<Int,AnyObject> = [:]
    var dateTime:Dictionary<Int,AnyObject> = [:]
    var product_items:Dictionary<Int,NSArray> = [:]
    var fAddressDic:Dictionary<Int,AnyObject> = [:]
    var fDateTime:Dictionary<Int,AnyObject> = [:]
    var filterCheck=false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var openOrderBtn: UIButton!
    @IBOutlet weak var paymentApprovedBtn: UIButton!
    @IBOutlet weak var orderReturnedBtn: UIButton!
    
    var deliveryaddressstatus : String!
    var orderstatus : String!
    var customerid : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
               //tableView.frame = CGRectMake(0, 50, 320, 200)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        openOrderBtn.layer.cornerRadius = 10
        paymentApprovedBtn.layer.cornerRadius = 10
        orderReturnedBtn.layer.cornerRadius = 10
       
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        back.isUserInteractionEnabled = true
        back.addGestureRecognizer(singleTap)
        
        
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getorderlist()
    }
    
    @objc func tapDetected() {
        print("Imageview Clicked")
        
        self.navigationController?.popViewController(animated: true)
        
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
       // let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: "store") as! StoreAdmin
        // If you want to push to new ViewController then use this
        //self.navigationController?.pushViewController(objSomeViewController, animated: true)
        
        //self.dismiss(animated: true, completion: nil)
        
    }
    
    func getorderlist()
    {
        
        addressarray.removeAll()
        orderdataarray.removeAll()
        productarray.removeAll()
        proVarientarray.removeAll()
        searcharray.removeAll()
        filtetAddressarray.removeAll()
        filtetProductarray.removeAll()
        
        self.dataarray.removeAllObjects()
        //print(self.dataarray)
        dbref = Database.database().reference().child("orderList")
        //observing the data changes
        
        dbref.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0
            {
                print(snapshot.key)
                self.products.removeAll()
                var i=0
                //iterating through all the values
                for product in snapshot.children.allObjects as! [DataSnapshot]
                {
                    if snapshot.hasChild(product.key)
                    {
                        self.dbref = Database.database().reference().child("orderList").child(product.key)
                        
                        self.dbref.observe(DataEventType.value, with: { (snapshot) in
                            
                            self.deliveryaddressstatus = "NO"
                            self.orderstatus = "NO"
                            
                            for data in snapshot.children.allObjects as! [DataSnapshot]{
                                //print(data)
                                print(snapshot.key)
                                self.customerid = snapshot.key
                                let dataObject =  data.value as? NSDictionary
                                let addressdetails = dataObject?.value(forKey: "deliveryDetails") as? NSDictionary
                                
                                let addressobject = addressdetails?.value(forKey: "address") as? NSDictionary
                                
                                let address = addressobject?.value(forKey: "address") as? String
                                let fulladdress = addressobject?.value(forKey: "fulladdress") as? String
                                let city = addressobject?.value(forKey: "city") as? String
                                let state = addressobject?.value(forKey: "state") as? String
                                let zip = addressobject?.value(forKey: "zip") as? String
                                
                                let deliveryobject = (addressdetails?.value(forKey: "deliveryTime") as? NSDictionary)
                                
                                let deliveryendtime = deliveryobject?.value(forKey: "endTime") as? String
                                let deliverystarttime = deliveryobject?.value(forKey: "startTime") as? String
                                
                                let deliveryTypeobject = (addressdetails?.value(forKey: "deliveryType") as? NSDictionary)
                                let orderdetails = dataObject?.value(forKey: "order") as? NSDictionary
                                
                                let Ordernumber = orderdetails?.value(forKey: "number") as? Int
                                print(Ordernumber)
                                let Total = orderdetails?.value(forKey: "total") as? Int
                                let Status = orderdetails?.value(forKey: "status") as? String
                                let Time = orderdetails?.value(forKey: "time") as? String
                                
                                let productdetails = dataObject?.value(forKey: "product") as! NSDictionary
                                
                                let productarr = NSMutableArray()
                                for (key,value) in productdetails {
                                    productarr.add(value)
                                }
                                if ((address != nil) && (fulladdress != nil) && (city != nil) && (state != nil) && (zip != nil) && (deliveryendtime != nil) && (Ordernumber != nil) && (Total != nil) && (Status != nil) && (Time != nil))
                                {

                                    for index in 0..<productarr.count
                                    {
                                        let Productdataobj = Orderlookupdetails()

                                        let productname = ((productarr.value(forKey: "name") as! NSArray).object(at: index) as? String)
                                        let timestamp = ((productarr.value(forKey: "timeStamp") as! NSArray).object(at: index) as? Int)
                                        let variantdict = (productarr.object(at: index)) as! NSDictionary
                                        
                                        var productID : String!

                                        let tempTestArr = variantdict.value(forKey: "productVariants") as? NSArray
                                        
                                        if ((productname != nil) && (tempTestArr != nil) && (timestamp != nil))
                                        {
                                            let productvarientarr = variantdict.value(forKey: "productVariants") as! NSMutableArray
                                            productID = (productarr.value(forKey: "id") as! NSArray).object(at: index) as! String
                                            Productdataobj.productvarient = []
                                            
                                            for (key, value) in productvarientarr.enumerated()
                                            {
                                                print("\(key) -> \(value)")
                                                
                                                if value as? NSDictionary != nil
                                                {
                                                    let valueArray = value as! [String: Any]
                                                    print(valueArray)
                                                    Productdataobj.productvarient.append(valueArray)
                                                   /* Productdataobj.CustomerId = self.customerid
                                                    Productdataobj.productID = productID
                                                    Productdataobj.ordernumber = String(format: "%d",Ordernumber!)
                                                    Productdataobj.productname = productname
                                                    Productdataobj.status = Status
                                                    self.productarray.append(Productdataobj) */
                                                }
                                            }
                                            if Productdataobj.productvarient.count != 0
                                            {
                                                Productdataobj.CustomerId = self.customerid
                                                Productdataobj.productID = productID
                                                Productdataobj.ordernumber = String(format: "%d",Ordernumber!)
                                                Productdataobj.productname = productname
                                                Productdataobj.timestamp = timestamp
                                                Productdataobj.status = Status
                                                self.productarray.append(Productdataobj)
                                            }  
                                        }
                                        else
                                        {
                                            print((productarr.value(forKey: "id") as! NSArray).object(at: index) as! String)
                                        }
                                    }
                                    
                                    if self.productarray.count != 0
                                    {
                                        let Deliverydataobj = Orderlookupdetails()
                                        Deliverydataobj.address = address!
                                        Deliverydataobj.fulladdress = fulladdress!
                                        Deliverydataobj.city = city!
                                        Deliverydataobj.state = state!
                                        Deliverydataobj.zip = zip!
                                        Deliverydataobj.CustomerId = self.customerid
                                        Deliverydataobj.status = Status
                                        Deliverydataobj.ordernumber = String(format: "%d",Ordernumber!)
                                        Deliverydataobj.deliverystarttime = deliverystarttime
                                        Deliverydataobj.deliveryendtime = deliveryendtime
                                        self.addressarray.append(Deliverydataobj)
                                        
                                        let Orderdataobj = Orderlookupdetails()
                                        Orderdataobj.CustomerId = self.customerid
                                        Orderdataobj.ordernumber = String(format: "%d",Ordernumber!)
                                        Orderdataobj.status = Status
                                        Orderdataobj.time = Time!
                                        Orderdataobj.total = Total!
                                        self.orderdataarray.append(Orderdataobj)
                                    }
                                }
                            }
                        })
                    }
                }
            }

            DispatchQueue.main.async {
                //reloading the tableview
                self.tableView.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(filterCheck==true)
        {
            print ("searcharray.count \(searcharray.count)")
            return searcharray.count
        }
        else
        {
             print ("orderdataarray.count \(orderdataarray.count)")
            return orderdataarray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order_lookup", for: indexPath) as! Order_Lookup_Cell
        cell.status.layer.cornerRadius = 10
        cell.status.clipsToBounds = true
        
       // print(orderdataarray[indexPath.row].ordernumber)
        
        if((filterCheck==false) && (orderdataarray.count != 0) )
        {
            
            cell.order_id.text = String(format: "Order ID: %@",orderdataarray[indexPath.row].ordernumber)
            
            cell.totallbl.text = String(format: "Total: $%.2f", Float(orderdataarray[indexPath.row].total))
            
            cell.status.setTitle(String(format: " %@",(orderdataarray[indexPath.row].status)),for: .normal)
            
            cell.name.text = String(format: "%@",addressarray[indexPath.row].city)
            
            let isoDate = (String(format: "%@",orderdataarray[indexPath.row].time))
            let order_dateFormatter = DateFormatter()
            order_dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            order_dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            let ordertime = order_dateFormatter.date(from: isoDate )
            order_dateFormatter.dateFormat = "MM/d h:mm a" //Your New Date format as per requirement change it own
            let order_newDate = order_dateFormatter.string(from: ordertime!)
            cell.timelbl.text = String(format: "%@",order_newDate)
            
            let starttimevalue = (String(format: "%@",addressarray[indexPath.row].deliverystarttime!))
            let sorder_dateFormatter = DateFormatter()
            sorder_dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            //sorder_dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            let starttimeformat = sorder_dateFormatter.date(from: starttimevalue )
            sorder_dateFormatter.dateFormat = "MM/d h a" //Your New Date format as per requirement change it own
            let dstartime = sorder_dateFormatter.string(from: starttimeformat!)
            //print(dstartime)
            
            let endtimevalue = (String(format: "%@",addressarray[indexPath.row].deliveryendtime!))
            let eorder_dateFormatter = DateFormatter()
            eorder_dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            //sorder_dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            let endtimeformat = eorder_dateFormatter.date(from: endtimevalue )
            eorder_dateFormatter.dateFormat = "h a" //Your New Date format as per requirement change it own
            let dendtime = eorder_dateFormatter.string(from: endtimeformat!)
            //print(dendtime)
            
            cell.name.text = String(format: "%@",addressarray[indexPath.row].city)
            
            cell.deliveryBy.text = String(format: "Deliver by %@ - %@",dstartime,dendtime)
        }
        else
        {
            if searcharray.count != 0 {
                cell.order_id.text = String(format: "Order ID: %@",searcharray[indexPath.row].ordernumber)
                
                cell.totallbl.text = String(format: "Total: $%.2f", Float(searcharray[indexPath.row].total))
                
                cell.status.setTitle(String(format: " %@",(searcharray[indexPath.row].status)),for: .normal)
                
                cell.name.text = String(format: "%@",filtetAddressarray[indexPath.row].city)
                
                let isoDate = (String(format: "%@",searcharray[indexPath.row].time))
                let order_dateFormatter = DateFormatter()
                order_dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                order_dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
                let ordertime = order_dateFormatter.date(from: isoDate )
                order_dateFormatter.dateFormat = "MM/d h:mm a" //Your New Date format as per requirement change it own
                let order_newDate = order_dateFormatter.string(from: ordertime!)
                cell.timelbl.text = String(format: "%@",order_newDate)
                
                let starttimevalue = (String(format: "%@",filtetAddressarray[indexPath.row].deliverystarttime!))
                let sorder_dateFormatter = DateFormatter()
                sorder_dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                //sorder_dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
                let starttimeformat = sorder_dateFormatter.date(from: starttimevalue )
                sorder_dateFormatter.dateFormat = "MM/d h a" //Your New Date format as per requirement change it own
                let dstartime = sorder_dateFormatter.string(from: starttimeformat!)
                //print(dstartime)
                
                let endtimevalue = (String(format: "%@",filtetAddressarray[indexPath.row].deliveryendtime!))
                let eorder_dateFormatter = DateFormatter()
                eorder_dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                //sorder_dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
                let endtimeformat = eorder_dateFormatter.date(from: endtimevalue )
                eorder_dateFormatter.dateFormat = "h a" //Your New Date format as per requirement change it own
                let dendtime = eorder_dateFormatter.string(from: endtimeformat!)
                //print(dendtime)
                
                cell.name.text = String(format: "%@",filtetAddressarray[indexPath.row].city)
                
                cell.deliveryBy.text = String(format: "Deliver by %@ - %@",dstartime,dendtime)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(filterCheck==false)
        {
            selectedorderarr.removeAll()
            selectedaddressarr.removeAll()
            selectedproductarr.removeAll()
            
            print(selectedorderarr.count)
            print(selectedaddressarr.count)
            print(selectedproductarr.count)
            
            print(productarray[indexPath.row].ordernumber)
            selectedorderarr = [orderdataarray[indexPath.row]]
            selectedaddressarr = [addressarray[indexPath.row]]
            customerkey = orderdataarray[indexPath.row].CustomerId
            customerorderno = orderdataarray[indexPath.row].ordernumber
            print(customerkey)
            print(customerorderno)
            print(orderdataarray[indexPath.row].ordernumber)
            print(self.proVarientarray)
            filterselectedarray(orderid: orderdataarray[indexPath.row].ordernumber)
            
            print(selectedorderarr.count)
            print(selectedaddressarr.count)
            print(selectedproductarr.count)
            print(productarray.count)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "orderdetails") as! OrderDetails
            navigationController?.pushViewController(abcViewController, animated: true)
            
        }
        else
        {
            selectedorderarr.removeAll()
            selectedaddressarr.removeAll()
            selectedproductarr.removeAll()
            //selectedorderarr = []
           // selectedaddressarr = []
            //selectedproductarr = []
            print(selectedorderarr.count)
            print(selectedaddressarr.count)
            print(selectedproductarr.count)
            
            print(filtetProductarray[indexPath.row].ordernumber)
            selectedorderarr = [searcharray[indexPath.row]]
            selectedaddressarr = [filtetAddressarray[indexPath.row]]
            customerkey = searcharray[indexPath.row].CustomerId
            customerorderno = searcharray[indexPath.row].ordernumber
            print(customerkey)
            print(customerorderno)
          //  print(searcharray[indexPath.row].ordernumber)
           // print(self.proVarientarray)
            filterselectedarray(orderid: searcharray[indexPath.row].ordernumber)
            print(selectedproductarr)
            
            print(filtetAddressarray.count)
            print(searcharray.count)
            print(filtetProductarray.count)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "orderdetails") as! OrderDetails
            navigationController?.pushViewController(abcViewController, animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searcharray.removeAll()
        filtetAddressarray.removeAll()
        filtetProductarray.removeAll()
        
        if (searchText.count>0)
        {
            filterCheck = true
            
            for x in 0..<orderdataarray.count
            {
                let Order: Orderlookupdetails
                
                Order = orderdataarray[x]
                
                let yaddress=addressarray[x]
                
                let xorder=orderdataarray[x]
                
                let xproduct=productarray[x]
                
                print(searchText)
                
                do {
                    
                    let input = "\(Order.ordernumber!)"
                    
                    let regex = try NSRegularExpression(pattern: searchText, options: NSRegularExpression.Options.caseInsensitive)
                    
                    let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
                    
                    for match in matches {
                        
                        if let range = Range(match.range, in: input) {
                            
                            let name = input[range]
                            
                            print(name)
                            
                            searcharray.append(xorder)
                            filtetAddressarray.append(yaddress)
                            filtetProductarray.append(xproduct)
                            print(searcharray.count)
                            print(filtetAddressarray.count)
                            print(filtetProductarray.count)
                            
                            self.tableView.reloadData()
                        }
                        
                    }
                    
                } catch {
                    
                    // regex was bad!
                }
            }
        }
        else
        {
            filterCheck = false
        }
        tableView.reloadData()
        
    }
    
    func filterselectedarray(orderid: String){
        
        if (orderid.count>0)
        {
            selectedproductarr.removeAll()

            for x in 0..<productarray.count
            {
                let Order: Orderlookupdetails
                
                Order = productarray[x]
                
                let yprod=productarray[x]
                
                print(orderid)
                
                do {
                    
                    let input = "\(Order.ordernumber!)"
                    
                    let regex = try NSRegularExpression(pattern: orderid, options: NSRegularExpression.Options.caseInsensitive)
                    
                    let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
                    
                    for match in matches {
                        
                        if let range = Range(match.range, in: input) {
                            
                            let name = input[range]
                            
                            print(name)
                            
                            selectedproductarr.append(yprod)
                            print(selectedproductarr.count)
                        }
                        
                    }
                    
                } catch {
                    
                    // regex was bad!
                }
            }
        }
        else
        {
        }
        return
    }
   
    @IBAction func OpenOrder(_ sender: Any) {
        let str="complete".lowercased()
        filterFunction(message: str)
    }
    
    @IBAction func PaymentApproved(_ sender: Any) {
        let str="Payment Approved".lowercased()
        filterFunction(message: str)
    }
    
    @IBAction func OrderReturned(_ sender: Any) {
        let str="Return Started".lowercased()
        filterFunction(message: str)
    }
    
    func filterFunction(message: String) {

        if (message.count>0)
        {
            filterCheck = true
            
            searcharray.removeAll()

            
            for x in 0..<orderdataarray.count
            {
                let Order: Orderlookupdetails
                
                Order = orderdataarray[x]
                
                let yaddress=addressarray[x]
                
                let xorder=orderdataarray[x]
                
                let xproduct=productarray[x]
                
                print(message)
                
                do {
                    
                    let input = "\(Order.status!)"
                    
                    let regex = try NSRegularExpression(pattern: message, options: NSRegularExpression.Options.caseInsensitive)
                    
                    let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
                    
                    for match in matches {
                        
                        if let range = Range(match.range, in: input) {
                            
                            let name = input[range]
                            
                            print(name)
                            
                            searcharray.append(xorder)
                            filtetAddressarray.append(yaddress)
                            filtetProductarray.append(xproduct)
                            print(searcharray.count)
                            print(filtetAddressarray.count)
                            print(filtetProductarray.count)
                            
                            self.tableView.reloadData()
                        }
                        
                    }
                    
                } catch {
                    
                    // regex was bad!
                }
            }
        }
        else
        {
            filterCheck = false
        }
        tableView.reloadData()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

