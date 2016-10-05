//
//  TabBarController.swift
//  
//
//  Created by 丸谷 浩永 on 8/22/16.
//
//

import UIKit
import CoreData

class TabBarController: UITabBarController {
    
    var managedObjectContext : NSManagedObjectContext? = nil
    fileprivate var fetchRequest : NSFetchRequest<RestaurantBasic>? = nil
    
    //Delegateで値を返す
    var _fetchedResultsController: NSFetchedResultsController<RestaurantBasic>? = nil
    
    //検索の絞り込み条件
    var criteria : Criteria = Criteria.getInstance()
    var changedCriteria = false
    var fetchBatchSize = 20
    
    //MARK: Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "firstLaunch") {
            setMasterData()
            defaults.set(false, forKey:"firstLaunch")
        }
        
        let tableViewController = viewControllers?[0].childViewControllers.first as! MasterViewController
        tableViewController.criteria = Criteria.getInstance()
        let mapViewController = viewControllers?[1].childViewControllers.first as! MapViewController
        mapViewController.criteria = Criteria.getInstance()
        
        if managedObjectContext == nil {
            fatalError("データ読み込みに失敗")
        }
        
        setupCenterButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: private functions
    
    //MARK: Center Button ( Home Button ) に関するメソッド
    fileprivate func setupCenterButton() {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.black
        button.sizeToFit()
        button.center = CGPoint(x: tabBar.bounds.size.width/2 , y: tabBar.bounds.size.height/2)
        button.addTarget(self, action: #selector(TabBarController.centerButtonTapped), for: .touchUpInside)
        tabBar.addSubview(button)
    }
    
    @objc fileprivate func centerButtonTapped(){
        clearCriteria()
        self.selectedIndex = 0
        let navigationController = viewControllers![0] as! UINavigationController
        navigationController.popToRootViewController(animated: true)
        self.changedCriteria = true
        (navigationController.topViewController as? MasterViewController)?.reloadFetchedData()
    }
    
    //MARK: Fetch Request に関するメソッド
    fileprivate func prepareFetchRequest(_ manegedObjectcontext:NSManagedObjectContext) -> NSFetchRequest<RestaurantBasic>? {
        //Entity, 検索結果の件数, ソート に関して設定を行う
        let entity : NSEntityDescription? = NSEntityDescription.entity(forEntityName: "RestaurantBasic", in: managedObjectContext!)
        let fetchRequest = NSFetchRequest<RestaurantBasic>()
        let sortDescriptor = NSSortDescriptor(key: "number", ascending: false)
        
        if entity != nil {
            fetchRequest.entity = entity
            fetchRequest.fetchBatchSize = fetchBatchSize
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        return fetchRequest
    }
    
    fileprivate func configureFetchRequest() {
        //キーワードからPredicateを作成
        var predicateWithKeyWord : NSPredicate? = nil
        let keyWord : NSString = criteria.keyWord as NSString
        
        if keyWord.length > 0 {
            let keyWordsArray = keyWord.components(separatedBy: " ")
            
            for key in keyWordsArray {
                if let predicate = predicateWithKeyWord{
                    let tempPredicateWithKeyWord = NSPredicate(format: "area CONTAINS '\(key)' || name CONTAINS '\(key)' || genre CONTAINS '\(key)' || introduction CONTAINS '\(key)'")
                    predicateWithKeyWord = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, tempPredicateWithKeyWord])
                }else{
                    predicateWithKeyWord = NSPredicate(format: "area CONTAINS '\(key)' || name CONTAINS '\(key)' || genre CONTAINS '\(key)' || introduction CONTAINS '\(key)'")
                }
            }
            
        }
        
        //場所からPredicateを作成
        var predicateWithArea : NSPredicate? = nil
        for (area, value) in (criteria.areaCriteria) {
            if value{
                if predicateWithArea == nil{
                    predicateWithArea = NSPredicate(format: "area = '\(area)'")
                }else {
                    let tempPredicateWithArea = NSPredicate(format: "area = '\(area)'")
                    predicateWithArea = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateWithArea!, tempPredicateWithArea])
                }
            }
        }
        
        //ジャンルからPredicateを作成
        var predicateWithGenre : NSPredicate? = nil
        for (genre, value) in (criteria.genreCriteria) {
            if value{
                if let predicate = predicateWithGenre{
                    let tempPredicateWithGenre = NSPredicate(format: "genre = '\(genre)'")
                    predicateWithGenre = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate, tempPredicateWithGenre])
                }else {
                    predicateWithGenre = NSPredicate(format: "genre = '\(genre)'")
                }
            }
        }
        
        //これまで作成したPredicatesをANDで組み合わせる
        var predicate : NSPredicate? = nil
        
        if predicateWithKeyWord != nil {
            predicate = predicateWithKeyWord
        }
        
        if predicateWithArea != nil {
            if predicate != nil {
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, predicateWithArea!])
            } else {
                predicate = predicateWithArea
            }
        }
        
        if predicateWithGenre != nil {
            if predicate != nil {
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, predicateWithGenre!])
            } else {
                predicate = predicateWithGenre
            }
        }
        
        //お気に入りのみのチェックがあればfavoriteからも絞り込みを行う
        if criteria.favorite {
            if predicate != nil {
                let predicateFavorite = NSPredicate(format: "favorite == YES")
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, predicateFavorite])
            }else {
                predicate = NSPredicate(format: "favorite == YES")
            }
        }
        
        self.fetchRequest?.predicate = predicate
        
        
    }
    
    //MARK: データ初期化に関するメソッド
    
    fileprivate func setMasterData() {
        
        let path:NSString = Bundle.main.path(forResource: "MasterData", ofType: "plist")! as NSString
        let masterDataArray:NSArray = NSArray(contentsOfFile : path as String)!
        let tempManagedObjectContext : NSManagedObjectContext = managedObjectContext!
        
        for item in masterDataArray {
            let dicts = item as! Dictionary<String, Dictionary<String, String>>
            
            let entityRestaurantBasic : NSEntityDescription! = NSEntityDescription.entity(
                forEntityName: "RestaurantBasic", in: tempManagedObjectContext
            )
            let entityRestaurantAdditional : NSEntityDescription! = NSEntityDescription.entity(
                forEntityName: "RestaurantAdditional", in: tempManagedObjectContext
            )
            let entityRestaurantBusiness : NSEntityDescription! = NSEntityDescription.entity(
                forEntityName: "RestaurantBusiness", in: tempManagedObjectContext
            )
            
            let newDataBasic  = RestaurantBasic(entity: entityRestaurantBasic, insertInto: tempManagedObjectContext)
            let newDataAdditional  = RestaurantAdditional(entity: entityRestaurantAdditional, insertInto: tempManagedObjectContext)
            let newDataBusiness  = RestaurantBusiness(entity: entityRestaurantBusiness, insertInto: tempManagedObjectContext)
            
            let basicDict = dicts["Basic"]
            for (key, value) in basicDict! {
                newDataBasic.setValue(value, forKey: key)
            }
            newDataBasic.setValue(false, forKey: "favorite")
            
            //Relationshipの定義
            
            newDataBasic.setValue(newDataAdditional, forKey: "additionalData")
            newDataBasic.setValue(newDataBusiness, forKey: "businessHours")
            
            /** additionalを使う際には実行
            let additionalDict = dicts["Additional"]
            for (key, value) in additionalDict! {
                newDataAdditional.setValue(value, forKey: key)
            }
            **/
            
            let businessDict = dicts["Business"]
            for (key, value) in businessDict! {
                newDataBusiness.setValue(value, forKey: key)
            }
            
            do {
                try tempManagedObjectContext.save()
            }catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    //MARK: 検索条件を初期化するメソッド
    
    func clearCriteria(){
        criteria.initializeCriteria()
    }
}

//MARK: setFavoriteDelegateのメソッド

/*
Custum Protocol

protocol SetFavoriteDelegate{
    func setFavorite(number: String, value: NSNumber)
}
*/

extension TabBarController : SetFavoriteDelegate{
    
    func setFavorite(_ number: String, value: NSNumber){
        
        //お気に入りの店として設定
        //店番号でデータをフェッチ -> レコードを変更して保存
        //（将来）データベースにお気に入りの店リストを作成して、店番号でRelationをつけるべきかも？
        
        var targetRecord : RestaurantBasic
        let fetchRequest = NSFetchRequest<RestaurantBasic>(entityName: "RestaurantBasic")
        
        fetchRequest.predicate = NSPredicate(format: "number = '\(number)'")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            print(error1)
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        targetRecord = fetchedResultsController.fetchedObjects![0]
        targetRecord.favorite = NSNumber(value: !(value.boolValue) as Bool)
        
        do {
            try managedObjectContext!.save()
        }catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }

}

//MARK: NSFetchedResultsControllerDelegateのメソッド

extension TabBarController : NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<RestaurantBasic> {
        
        if (_fetchedResultsController != nil) && (changedCriteria == false) {
            return _fetchedResultsController!
        }
        
        if fetchRequest == nil {
            let entity : NSEntityDescription? = NSEntityDescription.entity(forEntityName: "RestaurantBasic", in: managedObjectContext!)
            let tempFetchRequest = NSFetchRequest<RestaurantBasic>()
            let sortDescriptor = NSSortDescriptor(key: "number", ascending: false)
            
            if entity != nil {
                tempFetchRequest.entity = entity
                tempFetchRequest.fetchBatchSize = 20
                tempFetchRequest.sortDescriptors = [sortDescriptor]
            }
            
            fetchRequest = tempFetchRequest
        }
        
        if changedCriteria == true { configureFetchRequest() }
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest!, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName:nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch let error1 as NSError {
            print(error1)
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        changedCriteria = false
        //NSLog("fetched \(_fetchedResultsController?.fetchedObjects)")
        return _fetchedResultsController!
        
    }
}
