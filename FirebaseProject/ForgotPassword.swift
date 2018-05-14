//
//  ForgotPassword.swift
//  FirebaseProject
//
//  Created by Sathiyan Sivaprakasam on 11/04/18.
//  Copyright © 2018 Sathiyan Sivaprakasam. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPassword: UIViewController {

    
    @IBOutlet weak var forgotPassword: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        forgotPassword.isUserInteractionEnabled = true
        forgotPassword.addGestureRecognizer(singleTap)
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func tapDetected() {
        print("Imageview Clicked")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginController
        // If you want to push to new ViewController then use this
        self.navigationController?.pushViewController(objSomeViewController, animated: true)
    }
    
    @IBAction func Forgot(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: txtUserName.text!) { error in
            // Your code here
            if error == nil {
                print("user \(error)")
                let alert = UIAlertController(title: "Alert", message: "Link sent to your email", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Alert", message: "There is something problem in your email", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
