//
//  popoverCriteriaViewController.swift
//  京大周辺マップiPhone
//
//  Created by 丸谷 浩永 on 8/24/16.
//  Copyright © 2016 丸谷 浩永. All rights reserved.
//

import UIKit

class PopoverCriteriaViewController: UIViewController {
    
    
    @IBAction func buttonTapped(_ sender:AnyObject) {
        criteria.genreCriteria = genre
        criteria.areaCriteria = area
        self.previousViewController!.modalDidFinished()
    }
    
    @IBAction func resetButtonTapped(_ sender:AnyObject) {
        self.previousViewController!.modalResetTapped()
        self.viewWillAppear(false)
    }
    
    @IBAction func favariteOnlyTapped(_ sender:AnyObject) {
        let button = sender as! UIButton
        if criteria.favorite {
            criteria.favorite = false
            button.backgroundColor = UIColor.white
            button.setTitleColor(self.view.tintColor, for: UIControlState())
        }else {
            criteria.favorite = true
            button.backgroundColor = self.view.tintColor
            button.setTitleColor(UIColor.white, for: UIControlState())
        }
        changed += 1
    }
    
    @IBAction func pushedButton(_ sender : AnyObject) {
        var targetCriteria : [String : Bool]! = nil
        if let button = sender as? UIButton {
            switch button.tag {
            case 1...23 : targetCriteria = area  //変更
            case 25...40 : targetCriteria = genre  //変更
            default : return
                
            }
            //targetCriteria[(button.titleLabel?.text)!] = !(targetCriteria[(button.titleLabel?.text)!]!)
            
            if (targetCriteria[(button.titleLabel?.text)!])! == true {
                targetCriteria[(button.titleLabel?.text)!] = false
            }else {
                targetCriteria[(button.titleLabel?.text)!] = true
            }
            
            NSLog("\((button.titleLabel?.text)!), \(targetCriteria[(button.titleLabel?.text)!])")
            changed += 1
            
            let currentBackgroundcolor = button.backgroundColor
            button.backgroundColor = button.titleColor(for: UIControlState())
            button.setTitleColor(currentBackgroundcolor, for: UIControlState())
            
            switch button.tag {
            case 1...24 : area = targetCriteria
            case 25...42 : genre = targetCriteria
            default : return
            }
        }
    }
    
    var criteria : Criteria! = nil
    var changed = 0
    
    fileprivate var area : [String : Bool]! = nil
    fileprivate var genre : [String : Bool]! = nil
    
    var previousViewController : ModalViewControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        criteria = Criteria.getInstance()
        
        area = criteria.areaCriteria
        genre = criteria.genreCriteria
        
        configureButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureButtons() {
        
        //ソートに使用する配列
        let arrayForAreaSort = ["北山", "松ヶ崎", "一乗寺", "北大路", "下鴨", "高野", "北白川", "同志社周辺", "出町柳", "御蔭", "百万遍", "銀閣寺道", "丸太町", "神宮丸太町", "吉田", "浄土寺", "烏丸御池", "三条京阪", "岡崎", "蹴上", "四条烏丸", "四条河原町", "祇園"]
        
        var buttonTag = 1
        for i in 0...22 {
            let (key, value) = (arrayForAreaSort[i], area[arrayForAreaSort[i]])
            if buttonTag > 24 {break}
            if let button = self.view.viewWithTag(buttonTag) as? UIButton{
                button.setTitle(key, for: UIControlState())
                buttonTag += 1
                button.backgroundColor = UIColor.white
                
                if value == true {
                    button.backgroundColor = self.view.tintColor
                    button.setTitleColor(UIColor.white, for: UIControlState())
                }else {
                    button.backgroundColor = UIColor.white
                    button.setTitleColor(self.view.tintColor, for: UIControlState())
                }
            }
        }
        while buttonTag < 24 { self.view.viewWithTag(buttonTag)?.removeFromSuperview() ; buttonTag += 1 }
        
        let arrayForGenreSort = ["和食", "洋食", "中華", "麺類", "ラーメン・つけ麺", "多国籍", "カレー", "ファストフード", "丼物", "粉物", "焼肉", "焼き鳥", "パン", "カフェ", "スイーツ", "宴会"]
        
        buttonTag = 25
        for i in 0...15  {
            let (key, value) = (arrayForGenreSort[i], genre[arrayForGenreSort[i]])
            if buttonTag < 25 {break}
            if let button = self.view.viewWithTag(buttonTag) as? UIButton{
                button.setTitle(key, for: UIControlState())
                buttonTag += 1
                button.backgroundColor = UIColor.white
                
                if value == true {
                    button.backgroundColor = self.view.tintColor
                    button.setTitleColor(UIColor.white, for: UIControlState())
                }else {
                    button.backgroundColor = UIColor.white
                    button.setTitleColor(self.view.tintColor, for: UIControlState())
                }
            }
        }
        
        while buttonTag < 41
        { self.view.viewWithTag(buttonTag)?.removeFromSuperview() ; buttonTag += 1 }
        
        buttonTag = 97
        if let button = self.view.viewWithTag(buttonTag) as? UIButton {
            if criteria.favorite {
                button.backgroundColor = self.view.tintColor
                button.setTitleColor(UIColor.white, for: UIControlState())
            }else {
                button.backgroundColor = UIColor.white
                button.setTitleColor(self.view.tintColor, for: UIControlState())
            }
        }
        
     }
    
    

}
