//
//  Criteria.swift
//  京大周辺マップiPhone
//
//  Created by 丸谷 浩永 on 8/27/16.
//  Copyright © 2016 丸谷 浩永. All rights reserved.
//

import UIKit

class Criteria: NSObject {
    
    fileprivate static var instance : Criteria = Criteria()
    var areaCriteria : [String : Bool] = ["百万遍" : false,
                                          "北白川" : false,
                                          "御蔭" : false]
    
    var genreCriteria : [String : Bool] = ["中華" : false,
                                           "ラーメン" : false,
                                           "洋食" : false]
    var keyWord : String = ""
    
    var favorite : Bool = false
    
    static func getInstance() -> Criteria {
        return instance
    }
    
    func initializeCriteria() {
        areaCriteria = ["百万遍" : false,
                        "北白川" : false,
                        "御蔭" : false]
        genreCriteria = ["中華" : false,
                         "ラーメン" : false,
                         "洋食" : false]
        keyWord = ""
        
        favorite = false
    }

}
