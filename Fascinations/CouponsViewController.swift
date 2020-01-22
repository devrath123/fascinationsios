//
//  CouponsViewController.swift
//  Fascinations
//
//  Created by Devrath Rathee on 09/02/2017 A.
//  Copyright © 2019 Fascinations. All rights reserved.
//

import UIKit

class CouponsViewController: UIViewController {

    @IBOutlet weak var couponImage: UIImageView!
    @IBOutlet weak var couponDetails: UILabel!
    @IBOutlet weak var couponName: UILabel!
    var coupon : CouponBean?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backItem?.title = ""
        
        couponName.text = coupon?.couponName
        couponDetails.text = coupon?.couponDetails
        let url = URL(string: (coupon?.couponImage)!)
        let data = try? Data(contentsOf: url!)
        couponImage.image = UIImage(data: data!)
        
    }

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

}
