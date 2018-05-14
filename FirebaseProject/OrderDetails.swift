//
//  OrderDetails.swift
//  FirebaseProject
//
//  Created by Sathiyan Sivaprakasam on 13/04/18.
//  Copyright © 2018 Sathiyan Sivaprakasam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct OrderDetailsStruct {
    static var productname: AnyObject=NSNull.self
    static var productqty: AnyObject=NSNull.self
    static var productprice: AnyObject=NSNull.self
    static var producttimestamp: AnyObject=NSNull.self
}


class OrderDetails: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var checkbtnstatus : String!
    var returnstatusstr :String!
    var partialrefundamountvalue:String!
    var totalpartialrefund :String!
    var totalrefundamount: Float = 0.0
    
    var appDelegate = AppDelegate()
    
    var partailrefundarr = [PartialItems]()
    
    var checkstatusarr = NSMutableArray ()

    var addressDic:Dictionary<Int,AnyObject> = [:]
    var dateTime:Dictionary<Int,AnyObject> = [:]
    var product_items:Dictionary<Int,NSArray> = [:]
    
    @IBOutlet weak var refundsuccesslab: UILabel!
    @IBOutlet weak var orderdetailstitlelab: UILabel!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var datetime: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var deliverytime: UILabel!
    @IBOutlet weak var paymentStatus: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var orderReturn: UIButton!
    @IBOutlet weak var returnView: UIView!
    @IBOutlet weak var availableText: UILabel!
    var dbref  : DatabaseReference!

    @IBOutlet weak var detailsConst: NSLayoutConstraint!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var fullReturnView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var fullReturnBtn: UIButton!
    @IBOutlet weak var partialReturnBtn: UIButton!
    
    @IBOutlet weak var no: UIButton!
    @IBOutlet weak var yes: UIButton!
    @IBOutlet weak var refundAmound: UILabel!
    @IBOutlet weak var processRefund: UIButton!
    @IBOutlet weak var refundView: UIView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var orderLookupBtn: UIButton!
    var partialCheck=false
    @IBOutlet weak var homeBtn: UIButton!
    var orderNumber=0
    var reSellable="true"
    
    var listarray = [Orderlookupdetails]()

    override func viewWillAppear(_ animated: Bool) {
        
        listarray.removeAll()
       // listarray = []
        print(selectedproductarr.count)
        
        for index in 0..<selectedproductarr.count
        {
            let dataarray = (selectedproductarr[index].productvarient) as [[String:Any]]
            
            if dataarray.count == 1
            {
                let listarrayobj = Orderlookupdetails()
                listarrayobj.productID = selectedproductarr[index].productID
                listarrayobj.productname = selectedproductarr[index].productname
                listarrayobj.CustomerId = selectedproductarr[index].CustomerId
                listarrayobj.total = selectedproductarr[index].total
                listarrayobj.timestamp = selectedproductarr[index].timestamp
                listarrayobj.price = dataarray[0]["price"] as! Int
                listarrayobj.quantity = dataarray[0]["quantity"] as! Int
                listarray.append(listarrayobj)
            }
            else
            {
                for varientindex in 0..<dataarray.count
                {
                    let listarrayobj = Orderlookupdetails()
                    listarrayobj.productID = selectedproductarr[index].productID
                    listarrayobj.productname = selectedproductarr[index].productname
                    listarrayobj.CustomerId = selectedproductarr[index].CustomerId
                    listarrayobj.total = selectedproductarr[index].total
                    listarrayobj.timestamp = selectedproductarr[index].timestamp
                    listarrayobj.price = dataarray[varientindex]["price"] as! Int
                    listarrayobj.quantity = dataarray[varientindex]["quantity"] as! Int
                    listarray.append(listarrayobj)
                }
            }
        }
        
        for checkindex in 0..<listarray.count
        {
            let name = "0"
            checkstatusarr.add(name)
            print(checkstatusarr.object(at: checkindex) as! String)
        }
        
        self.tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(self.addressDica)
        // Do any additional setup after loading the view.
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        refundsuccesslab.isHidden = true
        
        detailsConst.constant=177
        refundView.isHidden=true
        successView.isHidden=true
        returnView.isHidden=true
        
        orderReturn.layer.cornerRadius = 5
        orderReturn.clipsToBounds = true
        
        deliveryAddress.text = selectedaddressarr[0].fulladdress
        customerName.text = ""
        orderId.text = String(format: "%@",selectedorderarr[0].ordernumber)
        total.text = String(format: "$%.2f", Float(selectedorderarr[0].total))
        refundAmound.text = (String(format: "TOTAL REFUND AMOUNT $%.2f",Float(selectedorderarr[0].total)))
        paymentStatus.text = selectedorderarr[0].status
        
        let isoDate = (String(format: "%@",selectedorderarr[0].time))
        let order_dateFormatter = DateFormatter()
        order_dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        order_dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let ordertime = order_dateFormatter.date(from: isoDate )
        order_dateFormatter.dateFormat = "MM/d h:mm a" //Your New Date format as per requirement change it own
        let order_newDate = order_dateFormatter.string(from: ordertime!)
        datetime.text = String(format: "%@",order_newDate)
        
        let starttimevalue = (String(format: "%@",selectedaddressarr[0].deliverystarttime))
        let sorder_dateFormatter = DateFormatter()
        sorder_dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        //sorder_dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let starttimeformat = sorder_dateFormatter.date(from: starttimevalue )
        sorder_dateFormatter.dateFormat = "h:mm a" //Your New Date format as per requirement change it own
        let dstartime = sorder_dateFormatter.string(from: starttimeformat!)
        //print(dstartime)
        
        let deliverdate = (String(format: "%@",selectedaddressarr[0].deliverystarttime))
        let dorder_dateFormatter = DateFormatter()
        dorder_dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let deliverdateformat = dorder_dateFormatter.date(from: deliverdate )
        dorder_dateFormatter.dateFormat = "MM/dd" //Your New Date format as per requirement change it own
        let ddeliverdate = dorder_dateFormatter.string(from: deliverdateformat!)
        print(ddeliverdate)
        
        let endtimevalue = (String(format: "%@",selectedaddressarr[0].deliveryendtime))
        let eorder_dateFormatter = DateFormatter()
        eorder_dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        //sorder_dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let endtimeformat = eorder_dateFormatter.date(from: endtimevalue )
        eorder_dateFormatter.dateFormat = "h:mm a" //Your New Date format as per requirement change it own
        let dendtime = eorder_dateFormatter.string(from: endtimeformat!)
        deliverytime.text = String(format: "%@ \n %@ - %@",ddeliverdate,dstartime,dendtime)
        
        
        /*deliveryAddress.text=String(format: ((orderDetailsStruct.address.value(forKey: "address") as! String)),((orderDetailsStruct.address.value(forKey: "city") as! String)))
        customerName.text=orderDetailsStruct.address.value(forKey: "name") as? String
        orderNumber=orderDetailsStruct.order.value(forKey: "number") as? Int ?? 0
        orderId.text=String(describing: "\(orderDetailsStruct.order.value(forKey: "number") as? Int ?? 0)")
        //total.text=String(describing: "$ \(orderDetailsStruct.order.value(forKey: "total") as? Float ?? 0)")
        let totalamountvalue =  String(format:"%@",(orderDetailsStruct.order.value(forKey: "total") as! CVarArg))
        let totalamountprice =  NSString(string: totalamountvalue).floatValue
        print(totalamountprice)
        refundAmound.text = (String(format: "TOTAL REFUND AMOUNT $%.2f",totalamountprice))
        total.text = (String(format: "$%.2f",totalamountprice))
        //refundAmound.text="TOTAL REFUND AMOUNT \(String(describing: "$ \(orderDetailsStruct.order.value(forKey: "total") as? Float ?? 0)"))"
        print("$ \(orderDetailsStruct.order.value(forKey: "total") as? Float ?? 0)")
        paymentStatus.text=orderDetailsStruct.order.value(forKey: "status") as? String
        
        //Order Date & Time
      
        
        //Delivery Time
        let delivert_isoDate = orderDetailsStruct.datetime.value(forKey: "endTime") as? String
        
        if orderDetailsStruct.datetime as? NSDictionary != nil
        {
            let delivert_dateFormatter = DateFormatter()
            delivert_dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            delivert_dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            let delivert_date = delivert_dateFormatter.date(from: delivert_isoDate!)!
            delivert_dateFormatter.dateFormat = "MM/dd, hh:mm a" //Your New Date format as per requirement change it own
            let delivert_newDate = delivert_dateFormatter.string(from: delivert_date)
            deliverytime.text = delivert_newDate
        }
        else
        {
            print("time field is empty")
        }*/
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        back.isUserInteractionEnabled = true
        back.addGestureRecognizer(singleTap)
            
        print(orderDetailsStruct.products.count)
        
    }
   // @objc func
    @objc func tapDetected() {
        print("Imageview Clicked")
       // let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
       // let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: "order") as! OrderLookup
        // If you want to push to new ViewController then use this
       // self.navigationController?.pushViewController(objSomeViewController, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order_details_cell", for: indexPath) as! OrderDetailCellTableViewCell
        
        cell.productName.text = listarray[indexPath.row].productname

        cell.price.text = String(format: "$%.2f",Float(listarray[indexPath.row].price as! Int))
        cell.qty.text = "\(String(describing: listarray[indexPath.row].quantity as! Int ))"
        
        if partialCheck==true
        {
            cell.checkbtn.isHidden = false
            print(checkstatusarr.object(at: indexPath.row) as! String)
            if (checkstatusarr.object(at: indexPath.row) as! String) == "0"
            {
                cell.checkbtn.isHidden=false
                cell.checkbtn.setBackgroundImage(UIImage(named:"check_box_empty"), for: UIControlState.normal)
                cell.checkbtn.addTarget(self, action: #selector(check), for: .touchUpInside)
            }
            else if (checkstatusarr.object(at: indexPath.row) as! String) == "1"
            {
                cell.checkbtn.isHidden=false
                cell.checkbtn.setBackgroundImage(UIImage(named:"checked_box"), for: UIControlState.normal)
                cell.checkbtn.addTarget(self, action: #selector(check), for: .touchUpInside)
                cell.checkbtn.isSelected = true
            }
        }
        else
        {
            cell.checkbtn.isHidden = true
        }
       
        
        return cell
    }
    
    @objc func check(sender: UIButton){
        
        let buttonRow = sender.tag
        let buttonPosition:CGPoint = sender.convert(.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        if (checkstatusarr.object(at: indexPath!.row) as! String) == "0"
        {
            sender.setBackgroundImage(UIImage(named:"checked_box"), for: UIControlState.normal)
            checkstatusarr.replaceObject(at: indexPath!.row, with: "1")
            
            if partailrefundarr.count == 0
            {
                let productname = listarray[indexPath!.row].productname
                let productprice = Float(listarray[indexPath!.row].price as! Int)
                let productqty = listarray[indexPath!.row].quantity as! Int
                let productid = listarray[indexPath!.row].productID
                let producttimestamp = listarray[indexPath!.row].timestamp
                let productsar = PartialItems(productid: productid as? String, productName: productname as? String, productQuantity: productqty as? Int, productPrice: productprice as? Float,producttimestamp: producttimestamp as? Int)
                self.partailrefundarr.append(productsar)
                
            }
            else
            {
                
                let productcheckid = listarray[indexPath!.row].productID
                print(partailrefundarr.count)
               
                let productname = listarray[indexPath!.row].productname
                let productprice = Float(listarray[indexPath!.row].price as! Int)
                let productqty = listarray[indexPath!.row].quantity as! Int
                let productid = listarray[indexPath!.row].productID
                let producttimestamp = listarray[indexPath!.row].timestamp
                let productsar = PartialItems(productid: productid as? String, productName: productname as? String, productQuantity: productqty as? Int, productPrice: productprice as? Float,producttimestamp: producttimestamp as? Int)
                self.partailrefundarr.append(productsar)
                
               /* for index in 0..<partailrefundarr.count
                {
                    let product: PartialItems
                    product = partailrefundarr[index]
                    
                    if product.productid == productcheckid
                    {
                        partailrefundarr.remove(at: index)
                    }
                    else
                    {
                       print("New Data")
                    }
                } */
                
            }
            
        }
        else if (checkstatusarr.object(at: indexPath!.row) as! String) == "1"
        {
            sender.setBackgroundImage(UIImage(named:"check_box_empty"), for: UIControlState.normal)
            checkstatusarr.replaceObject(at: indexPath!.row, with: "0")
            if partailrefundarr.count != 0
            {
                 let productcheckid = listarray[(indexPath?.row)!].productID
                    
                    for var index  in 0...partailrefundarr.count
                    {
                        let product: PartialItems
                        product = partailrefundarr[index]
                        
                        if product.productid == productcheckid
                        {
                            partailrefundarr.remove(at: index)
                            break
                        }
                    }
                }
            
            refundAmound.text = "SELECT PRODUCTS TO REFUND $ 0.00"
        }
        
        
        refundAmound.text = "SELECT PRODUCTS TO REFUND $ 0.00"
        totalrefundamount = 0.0
        
        for var i in 0..<partailrefundarr.count
        {
            
            let product: PartialItems
            let price = partailrefundarr[i].productPrice
            print(price!)
           
            let quantity = partailrefundarr[i].productQuantity
            print(quantity!)
            
            let totalprice = price! * Float(quantity as! Int)
            print(totalprice)
            totalrefundamount = totalrefundamount + totalprice
            print("totalrefundamount====",totalrefundamount)
            refundAmound.text = "SELECT PRODUCTS TO REFUND \(String(describing: "$ \(totalrefundamount)"))"
            
            
        }
        
        print("partailrefundarr================",partailrefundarr.count)
        tableView.reloadData()
    }
    
    
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetailsStruct.products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order_details_cell", for: indexPath) as! OrderDetailCellTableViewCell
        let getParticular=orderDetailsStruct.products [indexPath.row]
        
        if let myDictionary = getParticular as? [String : AnyObject] {
             let name = myDictionary["name"]
           // print("Product\(String(describing: name))")
            print(name)
            if name != nil
            {
                let productname = name as? String
                print("productname",productname!)
                cell.productName.text = name as? String
            }
            else
            {
                 cell.productName.text = ""
            }
            
            
            //let productprice = myDictionary["productVariants"]!
           // print(productprice)
           // let price = productprice.value(forKey: "price")![indexPath.row]
           // print(price)
            
           if let productprice = myDictionary["price"]
            {
                 cell.price.text = String(describing: "$ \(productprice)")
            }
            
           // cell.price.text = String(describing: "$ \(myDictionary["price"] as! NSNumber ?? 0)")
            if let productquantity = myDictionary["quantity"]
            {
                 cell.qty.text =  String(describing: "Qty \(productquantity)")
            }
            //cell.qty.text = String(describing: "Qty \(myDictionary["quantity"] as! NSNumber ?? 0)")
            
            print(partailrefundarr.count)
            if partialCheck==true
            {
                cell.checkbtn.isHidden = false
                print(checkstatusarr.object(at: indexPath.row) as! String)
                if checkstatusarr.object(at: indexPath.row) as! String == "0"
                {
                    cell.checkbtn.isHidden=false
                    cell.checkbtn.setBackgroundImage(UIImage(named:"check_box_empty"), for: UIControlState.normal)
                    cell.checkbtn.addTarget(self, action: #selector(check), for: .touchUpInside)
                }
                else
                {
                    cell.checkbtn.isHidden=false
                    cell.checkbtn.setBackgroundImage(UIImage(named:"checked_box"), for: UIControlState.normal)
                    cell.checkbtn.addTarget(self, action: #selector(check), for: .touchUpInside)
                    cell.checkbtn.isSelected = true
                }
            }
            else
            {
                 cell.checkbtn.isHidden = true
            }
        }
        return cell
    }
    
    
    @objc func check(sender: UIButton)
    {
        let buttonRow = sender.tag
        let buttonPosition:CGPoint = sender.convert(.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        //print(indexPath!)
        print(indexPath?.row as Any)
        
        
        
       // let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
       // let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
       // print(indexPath?.row as Any)
        
          print(partailrefundarr.count)
        if checkstatusarr.object(at: (indexPath!.row)) as! String == "0"
        {
            sender.setBackgroundImage(UIImage(named:"checked_box"), for: UIControlState.normal)
            checkstatusarr.replaceObject(at: indexPath!.row, with: "1")
            
            if partailrefundarr.count == 0
            {
                let getParticular=orderDetailsStruct.products [(indexPath?.row)!]
                if let myDictionary = getParticular as? [String : AnyObject] {
                    
                    let productname = myDictionary["name"]
                    print("Product\(String(describing: productname))")
                    let productprice = String(describing: "$ \(myDictionary["price"] as! NSNumber ?? 0)")
                    let productqty = String(describing: "Qty \(myDictionary["quantity"] as! NSNumber ?? 0)")
                    let productid = myDictionary["id"] as! String
                    let producttimestamp = String(describing: " \(myDictionary["timeStamp"] as! NSNumber ?? 0)")
                    let productsar = PartialItems(productid: productid as? String, productName: productname as? String, productQuantity: productqty as? String, productPrice: productprice as? String,producttimestamp: producttimestamp as? String)

                    self.partailrefundarr.append(productsar)

                }
            }
            else
            {
                let getParticular=orderDetailsStruct.products [(indexPath?.row)!]
                if let myDictionary = getParticular as? [String : AnyObject]
                {
                    let productname = myDictionary["name"] as! String
                    
                    for index in 0...partailrefundarr.count-1
                    {
                        let product: PartialItems
                        product = partailrefundarr[index]
                        
                        if product.productName == productname
                        {
                            partailrefundarr.remove(at: index)
                        }
                        else
                        {
                            let getParticular=orderDetailsStruct.products [(indexPath?.row)!]
                            if let myDictionary = getParticular as? [String : AnyObject] {
                                
                                let productname = myDictionary["name"]
                                print("Product\(String(describing: productname))")
                                let productprice = String(describing: "$ \(myDictionary["price"] as! NSNumber ?? 0)")
                                let productqty = String(describing: "Qty \(myDictionary["quantity"] as! NSNumber ?? 0)")
                                let productid = myDictionary["id"] as! String
                                let producttimestamp = String(describing: "\(myDictionary["timeStamp"] as! NSNumber ?? 0)")
                                let productsar = PartialItems(productid: productid as? String, productName: productname as? String, productQuantity: productqty as? String, productPrice: productprice as? String,producttimestamp: producttimestamp as? String)
                                self.partailrefundarr.append(productsar)
                            }
                        }
                    }
                }
            }
        }
        else
        {
            sender.setBackgroundImage(UIImage(named:"check_box_empty"), for: UIControlState.normal)
            checkstatusarr.replaceObject(at: indexPath!.row, with: "0")
            if partailrefundarr.count != 0
            {
                let getParticular=orderDetailsStruct.products [(indexPath?.row)!]
                if let myDictionary = getParticular as? [String : AnyObject]
                {
                    let productname = myDictionary["name"] as! String
                    
                    for var index  in 0..<partailrefundarr.count
                    {
                        let product: PartialItems
                        product = partailrefundarr[index]
                        
                        if product.productName == productname
                        {
                            partailrefundarr.remove(at: index)
                        }
                    }
                }
            }
           refundAmound.text = "SELECT PRODUCTS TO REFUND $ 0.00"
        }
        
         refundAmound.text = "SELECT PRODUCTS TO REFUND $ 0.00"
         totalrefundamount = 0.0
        for var i in 0..<partailrefundarr.count
        {
            
            let product: PartialItems
            let price = partailrefundarr[i].productPrice
            let pricavalue = price?.replacingOccurrences(of: "$ ", with:"")
            //print(pricavalue!)
            let quantity = partailrefundarr[i].productQuantity
            let quantityvalue =  quantity?.replacingOccurrences(of: "Qty", with:"")
            let totalprice = NSString(string: pricavalue!).floatValue * NSString(string: quantityvalue!).floatValue
           // print(NSString(string: pricavalue!).floatValue)
            //print(NSString(string: quantityvalue!).floatValue)
            //print("totalprice",totalprice)
            totalrefundamount = totalrefundamount + totalprice
            print("totalrefundamount====",totalrefundamount)
            refundAmound.text = "SELECT PRODUCTS TO REFUND \(String(describing: "$ \(totalrefundamount)"))"
            
           // print(price!)
            //checkstatusarr.add(name)
        }
        
        print(partailrefundarr.count)
        tableView.reloadData()
    }*/
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "order_details_cell", for: indexPath) as! OrderDetailCellTableViewCell
       // cell.check.image = #imageLiteral(resourceName: "checked_box")
        print(indexPath.row)
    
    }
    
    @IBAction func returnClick(_ sender: Any) {
        refundView.isHidden=false
        returnView.isHidden=false
        availableText.isHidden=true
        orderReturn.isHidden=true
        detailsConst.constant=304
        fullReturnView.isHidden=false
        scroll.contentSize = CGSize(width: scroll.contentSize.width, height: 800)
        orderdetailstitlelab.text = "RETURN ORDER"
        returnstatusstr = "fullreturn"
    }
    
    @IBAction func fullReturn(_ sender: Any) {
        
        returnstatusstr = "fullreturn"
        refundAmound.text = (String(format: "TOTAL REFUND AMOUNT $%.2f",Float(selectedorderarr[0].total)))
        fullReturnBtn.backgroundColor = UIColor.blue
        fullReturnBtn.setTitleColor(.white, for: .normal)
        orderdetailstitlelab.text = "RETURN ORDER"
        partialReturnBtn.backgroundColor = UIColor.white
        partialReturnBtn.setTitleColor(.blue, for: .normal)
        partialCheck=false
        tableView.reloadData()
    }
    @IBAction func partialReturn(_ sender: Any) {
        
        returnstatusstr = "partialreturn"
        orderdetailstitlelab.text = "RETURN ORDER"
        refundAmound.text = "SELECT PRODUCTS TO REFUND \(String(describing: "$ \(totalrefundamount)"))"
        fullReturnBtn.backgroundColor = UIColor.white
        fullReturnBtn.setTitleColor(.blue, for: .normal)
        partialReturnBtn.backgroundColor = UIColor.blue
        partialReturnBtn.setTitleColor(.white, for: .normal)
        partialCheck=true
        print(orderDetailsStruct.products.count)
        tableView.reloadData()

    }
    
    @IBAction func Yes(_ sender: Any) {
        yes.backgroundColor = UIColor.black
        yes.setTitleColor(.white, for: .normal)
        no.backgroundColor = UIColor.lightGray
        no.setTitleColor(.white, for: .normal)
        reSellable = "true"

    }
    @IBAction func No(_ sender: Any) {
        no.backgroundColor = UIColor.black
        no.setTitleColor(.white, for: .normal)
        yes.backgroundColor = UIColor.lightGray
        yes.setTitleColor(.white, for: .normal)
        reSellable = "false"

    }
    
    @IBAction func Home(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: "store") as! StoreAdmin
        // If you want to push to new ViewController then use this
        self.navigationController?.pushViewController(objSomeViewController, animated: true)
    }
    @IBAction func OrderLookup(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: "order") as! OrderLookup
        // If you want to push to new ViewController then use this
        self.navigationController?.pushViewController(objSomeViewController, animated: true)
    }
    
    @IBAction func processRefund(_ sender: Any) {
        
        if returnstatusstr == "partialreturn"
        {
            if partailrefundarr.count == 0
            {
                let alert = UIAlertController(title: "Alert", message: "Please select product to refund.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                partialReturnBtn.isHidden = false
            }
            else
            {
                refundView.isHidden=true
                successView.isHidden=false
                fullReturnBtn.isHidden = true
                partialReturnBtn.isHidden = true
                refundsuccesslab.isHidden = false
            }
        }
        else
        {
            refundView.isHidden=true
            successView.isHidden=false
            fullReturnBtn.isHidden = true
            partialReturnBtn.isHidden = true
            refundsuccesslab.isHidden = false
        }
        
       
        
        if  returnstatusstr == "fullreturn"
        {
            //Testing
            dbref = Database.database().reference().child("orderList").child(customerkey).child(customerorderno).child("order")
            dbref.child("status").setValue("Return Started")
            
            dbref = Database.database().reference().child("orderList").child(customerkey).child(customerorderno).child("order")
            let profile = dbref.child(byAppendingPath: "returnDetails")
            var user = [String:String]()
           // user["firstName"] = orderDetailsStruct.address.value(forKey: "name") as? String
            user["returnTotal"] = String(format: "$%.2f", Float(selectedorderarr[0].total))
            profile.setValue(user)
            
            let order = profile.child(byAppendingPath: "products")
            var productArr = [String:String]()
            
            for x in 0..<listarray.count {
                productArr.removeAll()
                //let getParticular=orderDetailsStruct.products [x]
                //let myDictionary = getParticular as? [String : AnyObject]
                // print(myDictionary)
                let product = order.childByAutoId()
                productArr["id"] = listarray[x].productID
                productArr["name"] = listarray[x].productname
                productArr["price"] = String(format: "%d",listarray[x].price as! Int)
                productArr["quantity"] = String(format: "%d",listarray[x].quantity as! Int)
                productArr["timeStamp"] = String(format: "%d",listarray[x].timestamp as! Int) 
                productArr["reselleble"] = reSellable
                product.setValue(productArr)
                returnstatusstr = ""
            }
            
        }
        else if returnstatusstr == "partialreturn"
        {
                dbref = Database.database().reference().child("orderList").child(customerkey).child(customerorderno).child("order")
                dbref.child("status").setValue("Return Started")
                
                dbref = Database.database().reference().child("orderList").child(customerkey).child(customerorderno).child("order")
                let profile = dbref.child(byAppendingPath: "returnDetails")
                var user = [String:String]()
                //user["firstName"] = orderDetailsStruct.address.value(forKey: "name") as? String
                user["returnTotal"] = String(describing: "$ \(totalrefundamount)")
                print("totalrefundamount====",totalrefundamount)
                print(String(describing: "$ \(totalrefundamount)"))
                profile.setValue(user)
                
                let order = profile.child(byAppendingPath: "products")
                var productArr = [String:String]()
                
                print(partailrefundarr.count)
            
                for x in 0..<partailrefundarr.count {
                    productArr.removeAll()
                    let getParticular=partailrefundarr [x]
                    let myDictionary = getParticular as? [String : AnyObject]
                    print(getParticular.productName!)
                    // print(myDictionary!)
                    let product = order.childByAutoId()
                    productArr["id"] = getParticular.productid!
                    productArr["name"] = getParticular.productName!
                    productArr["price"] = String(format: "%.2f",getParticular.productPrice!)
                    productArr["quantity"] = String(format: "%d",getParticular.productQuantity!)
                    productArr["timeStamp"] = String(format: "%d",getParticular.producttimestamp!) 
                    productArr["reselleble"] = reSellable
                    product.setValue(productArr)
                    returnstatusstr = ""
                
            }
            
        }
        

    }
}

