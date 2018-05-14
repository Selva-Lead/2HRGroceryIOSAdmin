//
//  LoginControllerViewController.swift
//  FirebaseProject
//
//  Created by Sathiyan Sivaprakasam on 11/04/18.
//  Copyright © 2018 Sathiyan Sivaprakasam. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func SignIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: txtUserName.text!, password: txtPassword.text!) { (user,error) in
            print("user \(user)")
            if user != nil{
                DispatchQueue.main.async(execute: {
                    // write code
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: "store") as! StoreAdmin
                    // If you want to push to new ViewController then use this
                    self.navigationController?.pushViewController(objSomeViewController, animated: true)
                })
            }else{
                let alert = UIAlertController(title: "Alert", message: "Authendication Failure", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func Forgot(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: "selin95crystal@gmail.com") { error in
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
    @IBAction func login(_ sender: Any) {
        Auth.auth().createUser(withEmail: txtUserName.text!, password: txtPassword.text!) {(user,error) in
            if error == nil {
                print("user \(user)")
            }else {
                print(error)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
