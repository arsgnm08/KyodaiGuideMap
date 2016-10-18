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
        self.explanation()
        self.menu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addButtons()
    }
    //お気に入りボタン、マップボタンのの追加
    func addButtons(){
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "☆", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailViewController.setFavorite)), UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailViewController.setMap))]
        if (restaurantBasicInfo!.favorite)!.boolValue {
            self.navigationItem.rightBarButtonItem!.title = "★"
        }
    }
    //お気に入りについて
    func setFavorite(){
        let tabBarController = self.tabBarController as? TabBarController
        tabBarController?.setFavorite((restaurantBasicInfo?.number)!, value: (restaurantBasicInfo?.favorite)!)
        
        if restaurantBasicInfo?.favorite == false {
            self.navigationItem.rightBarButtonItem!.title = "☆"
        }else {
            self.navigationItem.rightBarButtonItem!.title = "★"
        }
    }
    
    //詳細地図について
    func setMap() {
        let modalViewController = DetailMapViewController()
        modalViewController.restaurantBasicInfo = self.restaurantBasicInfo
        modalViewController.previousViewController = self
     //   self.navigationController?.pushViewController(modalViewController, animated: true)
        modalViewController.modalPresentationStyle = .custom
        //modalViewController.transitioningDelegate = self
        present(modalViewController, animated: true, completion: nil)
    }
    
    //データ受け渡し　追記
    /* func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segue") {
            // SecondViewControllerクラスをインスタンス化してsegue（画面遷移）で値を渡せるようにバンドルする
            var DetailMapView : DetailMapViewController = segue.destination as! DetailMapViewController
            // secondView（バンドルされた変数）に受け取り用の変数を引数とし_paramを渡す（_paramには渡したい値）
            // この時SecondViewControllerにて受け取る同型の変数を用意しておかないとエラーになる
            DetailMapView.restaurantBasicInfo = restaurantBasicInfo
        }
    }*/
    @objc fileprivate func setuprestaurantData() {
        
        }
    
    //ナビゲーションバーのタイトルについて
    func topTitle() {
        self.navigationItem.title = restaurantBasicInfo!.name
    }
    
    let theView = UIImageView()
    
    //写真について
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
        views[0].image = UIImage (named: "営業時間")
        views[1].image = UIImage (named: "定休日")
        views[2].image = UIImage (named: "予算")
        views[3].image = UIImage (named: "電話")
        views[4].image = UIImage (named: "予約")
        views[5].image = UIImage (named: "駐輪場")
        views[6].image = UIImage (named: "座席数")
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
    
}
/*
extension DetailViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return DetailMapCustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
*/

