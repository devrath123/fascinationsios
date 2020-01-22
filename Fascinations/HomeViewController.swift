//
//  HomeViewController.swift
//  Fascinations
//
//  Created by Devrath Rathee on 14/02/2017 A.
//  Copyright © 2019 Fascinations. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var x : Int = 10
    var isSideMenuHidden = true
    var selectedCoupon : CouponBean?
    var couponArray = [CouponBean]()
    
    @IBOutlet weak var couponsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        leftConstraint.constant = -200
        getBannersList()
        getCouponsList()
        
    }
    
    @IBAction func couponsAction(_ sender: Any){
        leftConstraint.constant = -200
        isSideMenuHidden = true
    }
    
    
    @IBAction func storeAction(_ sender: Any) {
        leftConstraint.constant = -200
        isSideMenuHidden = true
        performSegue(withIdentifier: "storeSegue", sender: self)
    }
    
    @IBAction func newsAction(_ sender: Any) {
        leftConstraint.constant = -200
        isSideMenuHidden = true
        performSegue(withIdentifier: "newsSegue", sender: self)
    }
    
    @IBAction func shopAction(_ sender: Any) {
        leftConstraint.constant = -200
        isSideMenuHidden = true
        performSegue(withIdentifier: "shopSegue", sender: self)
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        if isSideMenuHidden{
            self.view.sendSubview(toBack: couponsTableView)
            leftConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            leftConstraint.constant = -200
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        isSideMenuHidden = !isSideMenuHidden
    }
    
    
    func getBannersList() -> Void {
        let url = NSURL(string: "http://www.storiesforgames.com/fascinations/api/banners")!
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
                    
                    let bannersList:Array<Dictionary<String,Any>> = parseJSON["bannerlist"] as! Array<Dictionary<String,Any>>;
                    
                    DispatchQueue.main.async {
                        
                         self.scrollView.contentSize = CGSize(width: 375*bannersList.count, height: 350)
                        
                        for i in 0..<bannersList.count {
                            
                            let imageV = UIImageView(frame: CGRect(x: self.x, y: 20, width: 350, height: 350))
                       
                            let banner = bannersList[i] as [String : AnyObject]
                           imageV.dowloadFromServer(link: banner["banner_url"] as! String, contentMode: .scaleToFill)
                            
                            self.scrollView.addSubview(imageV)
                            
                            self.x = self.x + 375
                        }
                    }
                }
                
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }

    func getCouponsList() -> Void {
        let url = NSURL(string: "http://www.storiesforgames.com/fascinations/api/getallcoupon")!
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
                    
                    let couponsList:Array<Dictionary<String,Any>> = parseJSON["couponlist"] as! Array<Dictionary<String,Any>>;
                    
                    for i in 0 ..< couponsList.count{
                        
                        let couponDetail = couponsList[i] as [String : AnyObject]
                        
                        var couponId = couponDetail["id"] as? String
                        if couponId == nil{
                            couponId = ""
                        }
                        
                        var couponName = couponDetail["coupon_name"] as? String
                        if couponName == nil{
                            couponName = ""
                        }
                        
                        var couponDetails = couponDetail["coupon_detail"] as? String
                        if couponDetails == nil{
                            couponDetails = ""
                        }
                        
                        var couponImage = couponDetail["coupon_image"] as? String
                        if couponImage == nil{
                            couponImage = ""
                        }
                        
                        self.couponArray.append(CouponBean(
                            couponId:couponId!,
                            couponName : couponName!,
                            couponDetails:couponDetails!,
                            couponImage:couponImage!))
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.couponsTableView.reloadData()
                    }
                }
                
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.couponArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CouponCell = couponsTableView.dequeueReusableCell(withIdentifier: "couponCell") as! CouponCell
        
        let coupon = couponArray[indexPath.row] as CouponBean
        cell.couponCodeLabel.text = coupon.couponName
        cell.valueLabel.text = coupon.couponDetails
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCoupon = couponArray[indexPath.row]
        
        performSegue(withIdentifier: "couponDetailsSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "couponDetailsSegue"{
          if let vc = segue.destination as? CouponsViewController{
            vc.coupon = selectedCoupon
        }
        }
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
        // Dispose of any resources that can be recreated.
    }

}

extension UIImageView {
    func dowloadFromServer(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func dowloadFromServer(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
}
