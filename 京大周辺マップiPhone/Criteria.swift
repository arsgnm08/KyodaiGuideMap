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

    var areaCriteria : [String : Bool] = [
        "北山" : false,
        "松ヶ崎" : false,
        "一乗寺" : false,
        "北大路" : false,
        "下鴨" : false,
        "高野" : false,
        "北白川" : false,
        "同志社周辺" : false,
        "出町柳" : false,
        "御蔭" : false,
        "百万遍" : false,
        "銀閣寺道" : false,
        "丸太町" : false,
        "神宮丸太町" : false,
        "吉田" : false,
        "浄土寺" : false,
        "烏丸御池" : false,
        "三条京阪" : false,
        "岡崎" : false,
        "蹴上" : false,
        "四条烏丸" : false,
        "四条河原町" : false,
        "祇園" : false
    ]
    
    var genreCriteria : [String : Bool] = [
        "和食" : false,
        "洋食" : false,
        "中華" : false,
        "麺類" : false,
        "ラーメン・つけ麺" : false,
        "多国籍" : false,
        "カレー" : false,
        "ファストフード" : false,
        "丼物" : false,
        "粉物" : false,
        "焼肉" : false,
        "焼き鳥" : false,
        "パン" : false,
        "カフェ" : false,
        "スイーツ" : false,
        "宴会" : false
    ]
    var keyWord : String = ""
    
    var favorite : Bool = false
    
    static func getInstance() -> Criteria {
        return instance
    }
    
    func initializeCriteria() {
        
        for (key, _) in areaCriteria {
            areaCriteria[key] = false
        }
        
        for (key, _) in genreCriteria {
            genreCriteria[key] = false
        }
        
        keyWord = ""
        
        favorite = false
    }

}
