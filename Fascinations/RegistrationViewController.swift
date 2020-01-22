//
//  RegistrationViewController.swift
//  Fascinations
//
//  Created by Devrath Rathee on 09/02/2017 A.
//  Copyright © 2019 Fascinations. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registrationAction(_ sender: Any) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let dict = ["email": emailTextField.text ?? "",          "password":passwordTextField.text ?? "",
            "c_password":passwordTextField.text ?? "",
            "name":firstName + lastName,
            "username" : userNameTextField.text ?? ""] as [String: Any]
        
        if(emailTextField.text != "" && passwordTextField.text != "" &&
            firstNameTextField.text != "" && lastNameTextField.text != "" &&
            userNameTextField.text != ""){
            checkRegistration(loginDictionary: dict)
        }
        else{
            showAlert(message: "Enter all the fields")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkRegistration(loginDictionary : [String:Any]) -> Void {
        let jsonData = try? JSONSerialization.data(withJSONObject: loginDictionary, options: .prettyPrinted)
        let url = NSURL(string: "http://www.storiesforgames.com/fascinations/api/register")!
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
                    self.showAlert(message: "Error in Registration. Please try again later.")
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
    
    
    @IBAction func loginAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func termsAndConditionAction(_ sender: Any) {
        let url = NSURL(string: "https://www.fascinations.net/terms-conditions")!
        UIApplication.shared.openURL(url as URL)
    }
    
    
    func callHomeSegue() -> Void {
        performSegue(withIdentifier: "registerSegue", sender: self)
    }
    
    func showAlert(message : String) -> Void {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        OperationQueue.main.addOperation{
            self.present(alert, animated: true, completion: nil)
        }
    }

}
