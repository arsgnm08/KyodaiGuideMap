



//
//  MasterViewController.swift
//  京大周辺マップiPhone
//
//  Created by 丸谷 浩永 on 8/1/16.
//  Copyright (c) 2016 丸谷 浩永. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class MasterViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext? = nil
    var fetchRequest : NSFetchRequest<RestaurantBasic>? = nil
    var fetchedResultsController : NSFetchedResultsController<RestaurantBasic> {
        let tabBarController = self.tabBarController as? TabBarController
        return (tabBarController?.fetchedResultsController)!
    }
    var fetchedResultsArray : [RestaurantBasic]? = nil
    var searchBar: UISearchBar = UISearchBar()
    var criteria : Criteria! = nil
    var tableDataSize = 10
    
    private var activityIndicator : UIActivityIndicatorView!
    let viewController : PopoverCriteriaViewController = PopoverCriteriaViewController(nibName: "PopoverCriteriaViewController", bundle: nil)
    
    var locationManager : CLLocationManager? = nil
    var obtainedCurrentLocation : Bool = false
    
    
    var userLocation : CLLocationCoordinate2D? = nil {
        didSet {
            (self.tabBarController as? TabBarController)?.userLocation = userLocation
        }
    }
    
    //For Debug
    var countOfRequests = 0
    
    //MARK: Internal Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "更新")
        self.refreshControl?.addTarget(self, action:  #selector(MasterViewController.fetchMoreData), for: UIControlEvents.valueChanged)
        
        let tabBarController = self.tabBarController as? TabBarController
        tabBarController?.changedCriteria = true
        fetchedResultsArray = fetchedResultsController.fetchedObjects
        
        //現在地取得開始
        if CLLocationManager.locationServicesEnabled() {
        
            //configure locationManager
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestAlwaysAuthorization()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = 50
            locationManager?.startUpdatingLocation()
        }else {
            userLocation = CLLocationCoordinate2D(latitude: 35.022487, longitude: 135.779858)
        }
        
        showIndicator()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ビューを再表示する際にはデータをデータベースから改めて読み込む
        super.viewWillAppear(true)
        let tabBarController = self.tabBarController as? TabBarController
        tabBarController?.changedCriteria = true
        reloadFetchedData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //詳細のビューに飛ぶ際の処理
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
            let object = self.fetchedResultsController.object(at: indexPath)
                (segue.destination as! DetailViewController).restaurantBasicInfo = object
                segue.destination.hidesBottomBarWhenPushed = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsArray!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)  as? TableViewCell
        self.configureCell(cell!, atIndexPath: indexPath)
        return cell!
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    fileprivate func configureCell(_ cell: TableViewCell, atIndexPath indexPath: IndexPath) {
        //Table View のセルを設定
        let object = self.fetchedResultsArray![(indexPath as NSIndexPath).row]
        cell.basicInformation = object
        if obtainedCurrentLocation{
            if object.timeToTravel == nil {
                self.calculateTime((Double(object.longitude!)!, Double(object.latitude!)!), indexPath : indexPath)
            }else {
            self.changeTimeLabel(object.timeToTravel!, indexPath: indexPath)
            }
        }
    }
    
    func changeTimeLabel(_ travelTimeInSeconds : String, indexPath : IndexPath) {
        if let label = (self.tableView.cellForRow(at: indexPath) as? TableViewCell)?.viewWithTag(2) as? UILabel {
            let travelTimeInMinutes = Double(travelTimeInSeconds)!/60
            let labelText = (Double(Int(travelTimeInMinutes*10))/10).description
            label.text = labelText
            
            let labelBike = (self.tableView.cellForRow(at: indexPath) as? TableViewCell)?.viewWithTag(4) as? UILabel
            labelBike!.text = (Double(Int(travelTimeInMinutes*10/3))/10).description
            //NSLog("Time is \(labelBike!.text)")
        }
        
        NSLog("current array count is \(countOfRequests)")
        if countForIndicator == countOfRequests-1 {
            hideIndicator()
            countForIndicator = 0
            NSLog("Finish Indicator!")
        }else {
            countForIndicator += 1
            NSLog("current countForIndicator is \(countForIndicator)")
        }
        
    }
    
    var countForIndicator : Int = 0
    
    func showIndicator() {
        countForIndicator = 0
        self.activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        
        let centerY = self.view.center.y - (self.navigationController?.navigationBar.bounds.size.height)!
        
        activityIndicator.center = CGPoint(x: self.view.center.x, y: centerY)
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.6)
        activityIndicator.layer.cornerRadius = 8
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
 
    func hideIndicator() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    @objc func fetchMoreData() {
        
        let tabBarController = self.tabBarController as! TabBarController
        tableDataSize += 10
        tabBarController.fetchLimit = tableDataSize
        tabBarController.changedCriteria = true
        self.reloadFetchedData()
        self.refreshControl?.endRefreshing()

    }

}

//MARK: CLLocationManagerDelegate methods

extension MasterViewController : CLLocationManagerDelegate {
    
    //現在位置が更新された際に呼び出し
    @objc(locationManager:didUpdateLocations:)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = CLLocationCoordinate2D(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
        obtainedCurrentLocation = true
        
        self.tableView.reloadData()
    }
    
    //現在位置の読み込みに失敗した際に呼び出し
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        hideIndicator()
        NSLog("Error to obtain user location")
        self.tableView.reloadData()
    }
    
    //位置情報利用の権限について変更があった場合
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }

}

//MARK: ResultViewController methods

extension MasterViewController : ResultViewController {
    
    //データの再読み込み
    func reloadFetchedData() {
        fetchedResultsArray = fetchedResultsController.fetchedObjects
        countForIndicator = 0
        self.tableView.reloadData()
    }
}

//MARK: TableViewCellDelegate methods

extension MasterViewController : TableViewCellDelegate {
    
    //所用時間を計算
    func calculateTime(_ coordinate : (longitude : Double, latitude : Double), indexPath : IndexPath){
        
        if obtainedCurrentLocation {
            let currentLocation = CLLocationCoordinate2DMake(userLocation!.latitude, userLocation!.longitude)
            let destinationLocation = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)

            let source : MKMapItem = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation, addressDictionary: nil))
            let destination : MKMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destinationLocation, addressDictionary: nil))
            
            let request : MKDirectionsRequest = MKDirectionsRequest()
            request.source = source
            request.destination = destination
            request.requestsAlternateRoutes = false
            request.transportType = MKDirectionsTransportType.walking
            
            //NSLog(request.description)
            countOfRequests += 1
            NSLog("count of requests is \(countOfRequests)")
        
            var expectedTime : String? = ""
            let direction = MKDirections(request: request)
        
            let queue = DispatchQueue(label : "myQueue")
            queue.sync {
            
                direction.calculateETA(completionHandler: {
                    (response, error) in
            
                    if error == nil {
                        expectedTime = response?.expectedTravelTime.description
                        NSLog(expectedTime!)
                        self.fetchedResultsArray?[indexPath.row].timeToTravel = expectedTime
                        self.changeTimeLabel(expectedTime!, indexPath: indexPath)
                    
                    }else {
                        NSLog(request.description)
                        NSLog((error?.localizedDescription)!)
                    }
                })
            }
        }
    }
}


