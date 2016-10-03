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

    var restaurantBasicInfo : RestaurantBasic? = nil
    
    func configureView() {
        // Update the user interface for the detail item.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addButtons()
    }
    
    func addButtons(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "☆", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailViewController.setFavorite))
        if (restaurantBasicInfo!.favorite)!.boolValue {
            self.navigationItem.rightBarButtonItem!.title = "★"
        }
    }

    func setFavorite(){
        let tabBarController = self.tabBarController as? TabBarController
        tabBarController?.setFavorite((restaurantBasicInfo?.number)!, value: (restaurantBasicInfo?.favorite)!)
        
        if restaurantBasicInfo?.favorite == false {
            self.navigationItem.rightBarButtonItem!.title = "☆"
        }else {
            self.navigationItem.rightBarButtonItem!.title = "★"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

