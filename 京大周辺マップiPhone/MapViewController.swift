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

class MapViewController: UIViewController {

    //------------------------------
    //MARK: インスタンスプロパティの定義
    //------------------------------
    
    //マップビュー
    @IBOutlet var mapView : MKMapView!
    
    //フェッチしたデータ
    var fetchedResultsController : NSFetchedResultsController<RestaurantBasic> {
        let tabBarController = self.tabBarController as? TabBarController
        return (tabBarController?.fetchedResultsController)!
    }
    
    //ナビゲーションバーのプロパティ
    let viewController : PopoverCriteriaViewController = PopoverCriteriaViewController(nibName: "PopoverCriteriaViewController", bundle: nil)
    var searchBar: UISearchBar = UISearchBar()
    var criteria : Criteria! = nil
    
    //mapの初期中心座標＝現在地
    var userLocation : CLLocationCoordinate2D? = nil
    var currentLocation = CLLocation(latitude: 35.022487, longitude: 135.779858)

    //-------------------------
    //MARK: Internal functions
    //-------------------------
    
    //ビュー読み込み後の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarController = self.tabBarController as? TabBarController
        tabBarController?.changedCriteria = true
        
        //現在地が読み込まれていれば地図の中心を現在地に
        if let centerCoordinate = userLocation {
            currentLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        }
        
        //地図のプロパティを設定
        let coordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView!.region = coordinateRegion
        self.mapView!.delegate = self
        self.mapView.userTrackingMode = MKUserTrackingMode.follow
    }

    //ビューが表示される前の処理（再度表示の際も呼び出される）
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.mapView!.region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        let tabBarController = self.tabBarController as? TabBarController
        tabBarController?.changedCriteria = true
        reloadFetchedData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //画面遷移のための準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let annotationView = sender as? MKAnnotationView
        let annotation = annotationView!.annotation as? MyAnnotation
        let object = annotation!.restaurantInfo
        
        (segue.destination as! DetailViewController).restaurantBasicInfo = object
        //segue.destinationViewController.hidesBottomBarWhenPushed = true
        
    }

}

//-----------------------------
//MARK: configure annotations
//-----------------------------

extension MapViewController : MKMapViewDelegate {
    
    //マップビューにピンを立てるメソッド
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
    
    //ピンの詳細ボタンをタップした際の処理
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegue(withIdentifier: "showDetail", sender: view)
    }
}

//------------------------------------
//MARK: ResultViewController methods
//------------------------------------

extension MapViewController : ResultViewController {
    
    //フェッチしたデータの再読み込み
    func reloadFetchedData() {
        //現在表示しているピンを全て破棄
        let annotationsToRemove = mapView?.annotations.filter{ $0 !== mapView!.userLocation }
        mapView?.removeAnnotations(annotationsToRemove!)
        
        for item in fetchedResultsController.fetchedObjects! {
            let annotation = MyAnnotation(restaurantInfo: item )
            self.mapView?.addAnnotation(annotation)
        }
    }
}
