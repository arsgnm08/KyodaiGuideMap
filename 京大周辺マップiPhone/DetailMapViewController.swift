//
//  DetailMapView.swift
//  KyodaiGuideMapApp
//
//  Created by 宮辺清誉 on 2016/10/10.
//  Copyright © 2016年 丸谷 浩永. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class DetailMapViewController: UIViewController {
    let detailMapView = MKMapView()
    var userLocation : CLLocationCoordinate2D? = nil
    
    var previousViewController : UIViewController? = nil
    
    var restaurantBasicInfo : RestaurantBasic?
    
    @objc internal func page() {
        
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        // Viewの移動.
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailMapView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.view.addSubview(detailMapView)
        
        var currentLocation = CLLocation(latitude: 35.022487, longitude: 135.779858)
        
        if let centerCoordinate = userLocation {
            currentLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        }
        
        let coordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.detailMapView.region = coordinateRegion
        self.detailMapView.userTrackingMode = MKUserTrackingMode.follow
        
        //ナビゲーションバーを定義
        let navigationBar = UINavigationBar()
        navigationBar.frame = CGRect(x: 0, y: 22, width: self.view.bounds.width, height: 44)
        navigationBar.setItems([UINavigationItem()], animated: false)
        
        //戻るボタンを定義して、ナビゲーションバーの左端に表示
        let returnButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.page))
        navigationBar.topItem?.leftBarButtonItem = returnButton
        self.view.addSubview(navigationBar)
        
        //ピンを立てる
        let annotation = MyAnnotation(restaurantInfo: self.restaurantBasicInfo!)
        //let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(Double((restaurantBasicInfo?.latitude)!)!, Double((restaurantBasicInfo?.longitude)!)!)
        self.detailMapView.addAnnotation(annotation)
        
        //DetailViewController.restaurantBasicInfo = object
        //let object = annotation!.restaurantInfo
        
        
        //---------------------------------------------------------
        //上部分に書き直した（ナビゲーションバー中にボタンを表示する仕様に変更
        //---------------------------------------------------------
        /*
        let returnButton = UIButton()
        returnButton.setTitle("戻る", for: UIControlState.normal)
        returnButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        returnButton.frame = CGRect(x: 0, y: UIScreen.main.bounds.width / 20, width: UIScreen.main.bounds.width / 5 , height: 14)
        returnButton.addTarget(self, action: #selector(self.page), for: UIControlEvents.touchUpInside)
        self.view.addSubview(returnButton)
         */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension DetailMapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "Pin"
        var annotationView : MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotation is MKUserLocation { return nil }//現在地にはピンを立てない
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }else {
            annotationView?.annotation = annotation
        }
        annotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        return annotationView
    }
}
