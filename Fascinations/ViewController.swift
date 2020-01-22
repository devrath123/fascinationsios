//
//  ViewController.swift
//  Fascinations
//
//  Created by Devrath Rathee on 24/01/2017 A.
//  Copyright © 2019 Fascinations. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            
            let token = UserDefaults.standard.string(forKey: Constants.Login.TOKEN)
            
            if let tokenLength = token, tokenLength.count >= 0{
                self.navigateToMainViewController()
            }else{
                self.navigateToLoginViewController()
            }
            
        })
    }

    func navigateToMainViewController() -> Void{
        performSegue(withIdentifier: "MainSegue", sender: self)
    }
    
    func navigateToLoginViewController() -> Void{
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

