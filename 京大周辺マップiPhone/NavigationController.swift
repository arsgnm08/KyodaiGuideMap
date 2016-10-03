//
//  NavigationController.swift
//  KyodaiGuideMapApp
//
//  Created by 丸谷 浩永 on 9/18/16.
//  Copyright © 2016 丸谷 浩永. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UISearchBarDelegate, ModalViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ResultViewControllerDelegate Methods
    
    //MARK: configure bar buttons
    
    func addButtons() {
        setupSearchBar()
        self.viewControllers.first!.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"フィルタ", style:UIBarButtonItemStyle.Plain, target: self, action: #selector(NavigationController.setupCriteria))
    }
    
    func setupSearchBar() {
        let viewController = self.topViewController as! ResultViewController
        let navigationBarFrame = self.navigationBar.bounds
        let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.autocapitalizationType = UITextAutocapitalizationType.None
        searchBar.keyboardType = UIKeyboardType.Default
        self.viewControllers.first!.navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        self.viewControllers.first!.navigationItem.titleView?.frame = searchBar.frame
        viewController.searchBar = searchBar
        //searchBar.becomeFirstResponder()
    }
    
    func setupCriteria() {
        //configure popover view
        
        let presentingViewController = self.viewControllers.first as! ResultViewController
        let viewController = presentingViewController.viewController
        viewController.modalPresentationStyle = .Popover
        viewController.preferredContentSize = viewController.view.frame.size
        viewController.previousViewController = self
        
        if let presentationController = viewController.popoverPresentationController {
            presentationController.permittedArrowDirections = .Up
            presentationController.barButtonItem = self.viewControllers.first!.navigationItem.leftBarButtonItem
            presentationController.delegate = presentingViewController
        }
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        
        let tabBarController = self.tabBarController as! TabBarController
        tabBarController.criteria.keyWord = searchBar.text!
        tabBarController.changedCriteria = true
        
        let viewController = self.viewControllers.first as! ResultViewController
        viewController.reloadFetchedData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let tabBarController = self.tabBarController as! TabBarController
        tabBarController.criteria.keyWord = searchBar.text!
        tabBarController.changedCriteria = true
        let viewController = self.viewControllers.first as! ResultViewController
        viewController.reloadFetchedData()
    }
    
    func modalDidFinished() {
        let presentingViewController = self.viewControllers.first as! ResultViewController
        let viewController = presentingViewController.viewController
        viewController.dismissViewControllerAnimated(true, completion: nil)
        if viewController.changed > 0 {
            let tabBarController = self.tabBarController as! TabBarController
            tabBarController.changedCriteria = true
            presentingViewController.reloadFetchedData()
        }
    }

}
