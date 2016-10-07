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
    
    
    
    /*func sort (a: [String]) -> [String : Bool] {
    for (index, element) in a.enumerated() {
        var area: [String : Bool]
        area[element] = false
    }
        return area
    }
    
    let areaCriteria = sort(array)*/
    
    
   /* func sort() {
    var areaCriteria : [String : Bool] = [:]
    let array = ["北山", "松ヶ崎", "一乗寺", "北大路", "下鴨", "高野", "北白川", "同志社周辺", "出町柳", "御蔭", "百万遍", "銀閣寺道", "丸太町", "神宮丸太町", "吉田", "浄土寺", "烏丸御池", "三条京阪", "岡崎", "蹴上", "四条烏丸", "四条河原町", "祇園"]
    
    for item in array {
    areaCriteria[item] = false
    }
        return areaCriteria
    }
    */
    
    
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
        areaCriteria = [
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
        genreCriteria = [
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
        keyWord = ""
        
        favorite = false
    }

}
