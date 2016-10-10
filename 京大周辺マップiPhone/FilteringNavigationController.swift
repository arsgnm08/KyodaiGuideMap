//
//  FilteringNavigationController.swift
//  KyodaiGuideMapApp
//
//  Created by 丸谷 浩永 on 9/22/16.
//  Copyright © 2016 丸谷 浩永. All rights reserved.
//

import UIKit


class FilteringNavigationController: UINavigationController {

    //--------------------------
    //MARK: Internal functions
    //--------------------------
    
    //NavigationControllerを読み込み終わったらナビゲーションバーのボタンを配置
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
    }
    
    //ナビゲーションバーにボタンを配置
    fileprivate func addButtons() {
        setupSearchBar()
        self.viewControllers.first!.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"フィルタ", style:UIBarButtonItemStyle.plain, target: self, action: #selector(FilteringNavigationController.setupCriteria))
    }
    
    //検索バーを設定
    fileprivate func setupSearchBar() {
        let navigationBarFrame = self.navigationBar.bounds
        let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        searchBar.keyboardType = UIKeyboardType.default
        self.viewControllers.first!.navigationItem.titleView = searchBar
        //searchBar.showsCancelButton = true
        self.viewControllers.first!.navigationItem.titleView?.frame = searchBar.frame
        let viewController = self.viewControllers.first as! ResultViewController
        viewController.searchBar = searchBar
        //searchBar.becomeFirstResponder()
    }
    
    //-----------------------------
    //MARK: ナビゲーションバーのボタン
    //-----------------------------
    
    //フィルタのウィンドウを設定
    @objc fileprivate func setupCriteria() {
        
        let presentingViewController = self.topViewController as! ResultViewController
        let viewController = presentingViewController.viewController
        viewController.modalPresentationStyle = .popover
        viewController.preferredContentSize = presentingViewController.viewController.view.frame.size
        viewController.previousViewController = self
        
        if let presentationController = presentingViewController.viewController.popoverPresentationController {
            presentationController.permittedArrowDirections = .up
            presentationController.barButtonItem = self.topViewController!.navigationItem.leftBarButtonItem
            presentationController.delegate = self
        }
        present(presentingViewController.viewController, animated: true, completion: nil)
    }
    
    //キーボードを隠す
    @objc fileprivate func dismissKeyboard() {
        //self.view.endEditing(true)
        let viewController = self.topViewController as! ResultViewController
        viewController.searchBar.resignFirstResponder()
        let tabBarController = self.tabBarController as! TabBarController
        if let text : NSString = viewController.searchBar.text as NSString? {
            if text.length < 1 {
                viewController.searchBar.text = ""
                tabBarController.criteria.keyWord = ""
                tabBarController.changedCriteria = true
            }
        }
        for recognizer in self.view.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(recognizer)
        }
        viewController.reloadFetchedData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: UISearchBarDelegate Methods

extension FilteringNavigationController : UISearchBarDelegate {
    
    //Search Bar に文字入力を開始する際に、タップによるキャンセル操作を定義
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let tap = UITapGestureRecognizer(target: self, action: #selector(FilteringNavigationController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        return true
    }
    
    //キャンセルボタンをタップした際の動作（現在使っていない）
    /*
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        
        let tabBarController = self.tabBarController as! TabBarController
        tabBarController.criteria.keyWord = searchBar.text!
        tabBarController.changedCriteria = true
        
        let viewController = self.viewControllers.first as! ResultViewController
        viewController.reloadFetchedData()
        searchBar.resignFirstResponder()
    }
    */
 
    //検索を実行するボタンをタップした際の動作
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let tabBarController = self.tabBarController as! TabBarController
        tabBarController.criteria.keyWord = searchBar.text!
        tabBarController.changedCriteria = true
        let viewController = self.viewControllers.first as! ResultViewController
        viewController.reloadFetchedData()
        viewController.searchBar.resignFirstResponder()
    }

}

//MARK: ModalViewControllerDelegate Methods

extension FilteringNavigationController : ModalViewControllerDelegate {
    
    //フィルタのウィンドウを隠す際の処理
    func modalDidFinished() {
        let presentingViewController = self.viewControllers.first as! ResultViewController
        let viewController = presentingViewController.viewController
        viewController.dismiss(animated: true, completion: nil)
        if viewController.changed > 0 {
            let tabBarController = self.tabBarController as! TabBarController
            tabBarController.changedCriteria = true
            presentingViewController.reloadFetchedData()
        }
    }
    
    //リセットボタンをタップした際の動作
    func modalResetTapped() {
        let presentingViewController = self.viewControllers.first as! ResultViewController
        let tabBarController = self.tabBarController as! TabBarController
        tabBarController.clearCriteria()
        tabBarController.changedCriteria = true
        presentingViewController.searchBar.text = ""
        presentingViewController.reloadFetchedData()
        presentingViewController.viewController.dismiss(animated: true, completion: nil)
    }
}

extension FilteringNavigationController : UIPopoverPresentationControllerDelegate{
    
    //フィルタのウィンドウをにゅっと出す
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
