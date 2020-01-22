//
//  CouponBean.swift
//  Fascinations
//
//  Created by Devrath Rathee on 10/02/2017 A.
//  Copyright © 2019 Fascinations. All rights reserved.
//

import Foundation

class CouponBean : NSObject{
    var couponId:String?
    var couponName:String?
    var couponDetails:String?
    var couponImage:String?
    
     init(couponId:String, couponName : String,
          couponDetails:String, couponImage:String) {
        self.couponId = couponId
        self.couponName = couponName
        self.couponDetails = couponDetails
        self.couponImage = couponImage
    
        super.init()
    }
    
    
}
