//
//  MapViewController.swift
//  KyodaiGuideMapApp
//
//  Created by 丸谷 浩永 on 9/1/16.
//  Copyright © 2016 丸谷 浩永. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController/*, CLLocationManagerDelegate, MKMapViewDelegate*/ {

    @IBOutlet var mapView : MKMapView!
    var fetchedResultsController : NSFetchedResultsController<RestaurantBasic> {
        let tabBarController = self.tabBarController as? TabBarController
        return (tabBarController?.fetchedResultsController)!
    }
    
    let viewController : PopoverCriteriaViewController = PopoverCriteriaViewController(nibName: "PopoverCriteriaViewController", bundle: nil)
    var searchBar: UISearchBar = UISearchBar()
    var criteria : Criteria! = nil
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
/*    var myLocationManager = CLLocationManager()//ロケーションマネージャー生成
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarController = self.tabBarController as? TabBarController
        tabBarController?.changedCriteria = true
        
        let currentLocation = CLLocation(latitude: appDelegate.lat, longitude: appDelegate.lon)
        let coordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView!.region = coordinateRegion
        self.mapView!.delegate = self //現在地をマップ中心に
//        self.mapView!.showsUserLocation = true    機能していない
        self.mapView.userTrackingMode = MKUserTrackingMode.follow
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let tabBarController = self.tabBarController as? TabBarController
        tabBarController?.changedCriteria = true
        reloadFetchedData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let annotationView = sender as? MKAnnotationView
        let annotation = annotationView!.annotation as? MyAnnotation
        let object = annotation!.restaurantInfo
        
        (segue.destination as! DetailViewController).restaurantBasicInfo = object
        //segue.destinationViewController.hidesBottomBarWhenPushed = true
        
    }

}

//MARK: configure annotations

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "Pin"
        var annotationView : MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotation is MKUserLocation { return nil }//現在地にはピンを立てない
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegue(withIdentifier: "showDetail", sender: view)
    }
}

//MARK: ResultViewController methods

extension MapViewController : ResultViewController {
    
    func reloadFetchedData() {
        //remove annotations currently set
        let annotationsToRemove = mapView?.annotations.filter{ $0 !== mapView!.userLocation }
        mapView?.removeAnnotations(annotationsToRemove!)
        
        for item in fetchedResultsController.fetchedObjects! {
            let annotation = MyAnnotation(restaurantInfo: item )
            self.mapView?.addAnnotation(annotation)
        }
    }
}
