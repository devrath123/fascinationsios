//
//  Constants.swift
//  Fascinations
//
//  Created by Devrath Rathee on 07/02/2017 A.
//  Copyright © 2019 Fascinations. All rights reserved.
//

import Foundation

struct Constants {
    static var Base_Url = "http://deverybody.com/projects/public/api/"
    
    struct Login {
        static let LoginUrl = Constants.Base_Url + "login"
        static let RegistrationUrl  = Constants.Base_Url + "register"
        static let CouponListUrl = Constants.Base_Url + "getcoupons"
        static let BannersUrl = Constants.Base_Url + "banners"
        static let TOKEN = "Token"
    }

}
