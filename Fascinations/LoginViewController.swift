//
//  LoginViewController.swift
//  Fascinations
//
//  Created by Devrath Rathee on 07/02/2017 A.
//  Copyright © 2019 Fascinations. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }

    @IBAction func loginAction(_ sender: UIButton) {
   
        let dict = ["email": emailTextField.text ?? "", "password":passwordTextField.text ?? ""] as [String: Any]
        
        if(emailTextField.text != "" && passwordTextField.text != ""){
            checkLogin(loginDictionary: dict)
        }
        else{
            showAlert(message: "Email or Password cannot be blank")
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    func checkLogin(loginDictionary : [String:Any]) -> Void {
        let jsonData = try? JSONSerialization.data(withJSONObject: loginDictionary, options: .prettyPrinted)
        let url = NSURL(string: "http://www.storiesforgames.com/fascinations/api/login")!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data,response,error in
            if error != nil{
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                let firstKey =  json?.allKeys[0] as! String
                if firstKey == "error"{
                    self.showAlert(message: "Please enter valid Email and Password")
                    return
                }
                
                if let parseJSON = json {
                    
                    let result = parseJSON["success"] as! NSDictionary
                    
                    let token:String = result.value(forKey: "token") as! String
                    UserDefaults.standard.set(token, forKey: Constants.Login.TOKEN)
                    print("Token: \(token)")
                    OperationQueue.main.addOperation{
                        self.callHomeSegue()
                    }
                    
                }
                
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }

    func callHomeSegue() -> Void {
        performSegue(withIdentifier: "homeSegue", sender: self)
    }
    
    func showAlert(message : String) -> Void {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        OperationQueue.main.addOperation{
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
