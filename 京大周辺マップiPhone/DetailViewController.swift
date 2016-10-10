//
//  DetailViewController.swift
//  京大周辺マップiPhone
//
//  Created by 丸谷 浩永 on 8/1/16.
//  Copyright (c) 2016 丸谷 浩永. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //IBOutlets
    //@IBOutlet var name : UILabel?
    
    var restaurantBasicInfo : RestaurantBasic? = nil
    
    //func configureView() {
    // Update the user interface for the detail item.
    //name!.text = restaurantBasicInfo!.name
    // }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.configureView()
        self.topTitle()
        self.Photo()
        self.configureInformationLabels()
        
        //self.businessHours()
        //self.closeDay()
        //self.budget()
        //self.telephoneNUmber()
        //self.reserve()
        //self.bycicle()
        //self.seats()
        self.explanation()
        self.menu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addButtons()
    }
    //お気に入りボタンの追加
    func addButtons(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "☆", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailViewController.setFavorite))
        if (restaurantBasicInfo!.favorite)!.boolValue {
            self.navigationItem.rightBarButtonItem!.title = "★"
        }
    }
    //お気に入り機能について
    func setFavorite(){
        let tabBarController = self.tabBarController as? TabBarController
        tabBarController?.setFavorite((restaurantBasicInfo?.number)!, value: (restaurantBasicInfo?.favorite)!)
        
        if restaurantBasicInfo?.favorite == false {
            self.navigationItem.rightBarButtonItem!.title = "☆"
        }else {
            self.navigationItem.rightBarButtonItem!.title = "★"
        }
    }
    
    func topTitle() {
        self.navigationItem.title = restaurantBasicInfo!.name
    }
    
    let theView = UIImageView()
    
    func Photo() {
        theView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)!, width: UIScreen.main.bounds.size.width, height: (3 * UIScreen.main.bounds.size.width) / 4)
        theView.backgroundColor = UIColor.black
        let restaurantPhoto = restaurantBasicInfo?.photo as? RestaurantPhoto
        theView.image = restaurantPhoto?.photoData
        self.view.addSubview(theView)
        
    }
    //追加したメソッド　アイコンと情報について
    var views : [UIImageView] = []
    var labels : [UILabel] = []
    let iconsize = CGSize(width: UIScreen.main.bounds.size.width / 20, height: UIScreen.main.bounds.size.width / 20)
    
    func configureInformationLabels() {
        
        var iconPoint = CGPoint(x: UIScreen.main.bounds.size.width / 30, y: self.theView.frame.origin.y + self.theView.frame.size.height + UIScreen.main.bounds.size.width / 30)
        var reusableIconRect = CGRect(origin: iconPoint, size: iconsize)
        
        let labelSize = CGSize(width: UIScreen.main.bounds.size.width / 3, height: UIScreen.main.bounds.size.width / 20)
        var labelPoint = CGPoint(x: UIScreen.main.bounds.size.width / 30 + UIScreen.main.bounds.size.width / 15 , y: self.theView.frame.origin.y + self.theView.frame.size.height + UIScreen.main.bounds.size.width / 30)
        var reusableLabelRect = CGRect(origin: labelPoint, size: labelSize)
        
        for t in 0...3 {
            if t == 0 {
                iconPoint = CGPoint(x: iconPoint.x + (UIScreen.main.bounds.size.width / 3)*CGFloat(0), y: iconPoint.y)
                labelPoint = CGPoint(x: labelPoint.x + (UIScreen.main.bounds.size.width / 3)*CGFloat(0), y: labelPoint.y)
                reusableIconRect = CGRect(origin: iconPoint, size: iconsize)
                reusableLabelRect = CGRect(x: labelPoint.x, y: labelPoint.y, width: labelSize.width * 2, height: labelSize.height)
                
                let appendingIconView = UIImageView(frame: reusableIconRect)
                appendingIconView.backgroundColor = UIColor.blue
                views.append(appendingIconView)
                let appendingLabelView = UILabel(frame: reusableLabelRect)
                labels.append(appendingLabelView)
            } else {
                for i in 0...1 {
                    iconPoint = CGPoint(x: iconPoint.x + (UIScreen.main.bounds.size.width / 2)*CGFloat(i), y: iconPoint.y)
                    labelPoint = CGPoint(x: labelPoint.x + (UIScreen.main.bounds.size.width / 2)*CGFloat(i), y: labelPoint.y)
                    reusableIconRect = CGRect(origin: iconPoint, size: iconsize)
                    reusableLabelRect = CGRect(origin: labelPoint, size: labelSize)
                    
                    let appendingIconView = UIImageView(frame: reusableIconRect)
                    appendingIconView.backgroundColor = UIColor.blue
                    views.append(appendingIconView)
                    let appendingLabelView = UILabel(frame: reusableLabelRect)
                    labels.append(appendingLabelView)
                }
            }
            iconPoint = CGPoint(x: UIScreen.main.bounds.size.width / 30, y: iconPoint.y + (UIScreen.main.bounds.size.width / 20) + (UIScreen.main.bounds.size.width / 30))
            labelPoint = CGPoint(x: UIScreen.main.bounds.size.width / 30 + UIScreen.main.bounds.size.width / 15, y: labelPoint.y + (UIScreen.main.bounds.size.width / 20 + UIScreen.main.bounds.size.width / 30))
        }
        
        for item in views {
            self.view.addSubview(item)
        }
        for item in labels {
            self.view.addSubview(item)
        }
        
        //情報のテキスト
        labels[0].text = restaurantBasicInfo?.hour
        labels[1].text = restaurantBasicInfo?.closedDay
        labels[2].text = restaurantBasicInfo?.price
        labels[3].text = restaurantBasicInfo?.tel
        labels[4].text = restaurantBasicInfo?.reserve
        labels[5].text = restaurantBasicInfo?.park
        labels[6].text = restaurantBasicInfo?.seats
        
       //アイコンの画像
       /* views[0].image = UIImage (name: "")
        views[1].image = UIImage (name: "")
        views[2].image = UIImage (name: "")
        views[3].image = UIImage (name: "")
        views[4].image = UIImage (name: "")
        views[5].image = UIImage (name: "")
        views[6].image = UIImage (name: "")*/
    }
    
   //説明に関して
    let explanationTitle = UILabel()
    let explanationText = UILabel()
    
    func explanation(){
        if restaurantBasicInfo?.introduction == "" {
            return
        } else {
        explanationTitle.frame = CGRect(x: UIScreen.main.bounds.size.width / 30, y: views[6].frame.origin.y + views[6].frame.size.height + UIScreen.main.bounds.size.width / 30, width: UIScreen.main.bounds.size.width / 3, height: UIScreen.main.bounds.size.width / 30)
        explanationTitle.text = "概要"
        explanationTitle.textColor = UIColor.black
        self.view.addSubview(explanationTitle)
        
        explanationText.text = restaurantBasicInfo!.introduction
        explanationText.frame = CGRect(x: UIScreen.main.bounds.size.width / 20, y: explanationTitle.frame.origin.y + explanationTitle.frame.size.height + UIScreen.main.bounds.size.width / 20, width: UIScreen.main.bounds.size.width - 2 * UIScreen.main.bounds.size.width / 20, height: UIScreen.main.bounds.size.width / 4)
        explanationText.lineBreakMode = NSLineBreakMode.byWordWrapping
        explanationText.numberOfLines = 0
        explanationText.font = UIFont(name: "Arial Rounded MT Bold", size: UIScreen.main.bounds.size.width / 30)
        explanationText.sizeToFit()
        self.view.addSubview(explanationText)
    }
    }
    
    
    //おすすめメニューに関して
       func menu() {
        var menuLabels : [UILabel] = []
        var valueLabels: [UILabel] = []
        if restaurantBasicInfo?.menuFirst == "" {
            return
        } else {
        let menuLabelSize = CGSize(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 40)
        let valueLabelSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.size.width / 40)
        let menuLabelPoint = CGPoint(x: UIScreen.main.bounds.size.width / 30, y: explanationText.frame.origin.y + explanationText.frame.size.height + UIScreen.main.bounds.size.width / 20)
            let valueLabelPoint = CGPoint(x: UIScreen.main.bounds.size.width * 2 / 3, y: explanationText.frame.origin.y + explanationText.frame.size.height + UIScreen.main.bounds.size.width / 20)
       
            for i in 0...2 {
                let menuLabelPoint = CGPoint(x: menuLabelPoint.x, y: menuLabelPoint.y + UIScreen.main.bounds.size.width / 15 * CGFloat(i))
                let valueLabelPoint = CGPoint(x: valueLabelPoint.x, y: valueLabelPoint.y + UIScreen.main.bounds.size.width / 15 * CGFloat(i))
                let reusableMenuRect = CGRect(origin: menuLabelPoint, size: menuLabelSize)
                let apendingMenuLabel = UILabel(frame: reusableMenuRect)
                let reusableValueRect = CGRect(origin: valueLabelPoint, size: valueLabelSize)
                let apendingValueLabel = UILabel(frame: reusableValueRect)
                menuLabels.append(apendingMenuLabel)
                valueLabels.append(apendingValueLabel)
            }
            for item in menuLabels {
                self.view.addSubview(item)
            }
            for item in valueLabels {
                self.view.addSubview(item)
            }
            menuLabels[0].text = restaurantBasicInfo?.menuFirst
            menuLabels[1].text = restaurantBasicInfo?.menuSecond
            menuLabels[2].text = restaurantBasicInfo?.menuThird
            valueLabels[0].text = restaurantBasicInfo?.valueFirst
            valueLabels[1].text = restaurantBasicInfo?.valueSecond
            valueLabels[2].text = restaurantBasicInfo?.valueThird
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension DetailViewController {
    
}
