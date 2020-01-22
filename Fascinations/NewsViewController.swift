//
//  NewsViewController.swift
//  Fascinations
//
//  Created by Devrath Rathee on 26/01/2017 A.
//  Copyright © 2019 Fascinations. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: UIViewController {

    @IBOutlet weak var newswebview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

       getUrlList()
    
    }
    
    func getUrlList() -> Void {
        let url = NSURL(string: "http://www.storiesforgames.com/fascinations/api/url")!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let bearer = "Bearer " + UserDefaults.standard.string(forKey: Constants.Login.TOKEN)!
        request.addValue(bearer, forHTTPHeaderField:"Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data,response,error in
            if error != nil{
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                let firstKey =  json?.allKeys[0] as! String
                if firstKey == "error"{
                    self.showAlert(message: "Server Error")
                    return
                }
                
                if let parseJSON = json {
                    
                    let urlList:Array<Dictionary<String,Any>> = parseJSON["urls"] as! Array<Dictionary<String,Any>>;
                    
                    DispatchQueue.main.async {
                        
                        for i in 0..<urlList.count {
                    
                            let urlObject = urlList[i] as [String : AnyObject]
                            let urlName = urlObject["name"] as! String
                            if urlName == "news"{
                                let url = URL(string:urlObject["url"] as! String)
                                self.newswebview.load(URLRequest(url:url!))
                            }
                        }
                        
                    }
                }
                
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }
    
    func showAlert(message : String) -> Void {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        OperationQueue.main.addOperation{
            self.present(alert, animated: true, completion: nil)
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
