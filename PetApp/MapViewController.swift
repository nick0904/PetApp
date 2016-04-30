
//動物之家地址: 臺北市內湖區潭美街 852 號

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    //地圖
    var m_mapView:MKMapView!
    var geocoder:CLGeocoder!
    var m_mapRegion:MKCoordinateRegion?
    var m_mapSpan:MKCoordinateSpan?
    var m_mapCnter:CLLocationCoordinate2D?
    var addressStr:String = ""
    var annotationSubtitle:String = ""
    var imgName:String = ""
    
    //定位
    var m_locationManeger:CLLocationManager? //定位管理者
    var m_longitude:CLLocationDegrees? //經度
    var m_latitude:CLLocationDegrees? //緯度
    var m_heading:CLLocationDirection?//面朝方位(指北針用)
    
    //位置查詢
    var m_geocoder:CLGeocoder! //世界座標地址查詢
    
//MARK: - refreshWithFrame
//------------------------
    func refreshWithFrame(frame:CGRect) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "我的位置", style: .Plain, target: self, action: #selector(MapViewController.onBarBtItemAction(_:)))
        
        //map
        m_mapView = MKMapView(frame: frame)
        m_mapView.delegate = self
        self.view.addSubview(m_mapView)
        
        //m_locationManeger
        self.m_locationManeger = CLLocationManager()
        self.m_locationManeger?.delegate = self
        m_locationManeger?.desiredAccuracy = kCLLocationAccuracyBest

        //m_geocoder
        m_geocoder = CLGeocoder()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if m_geocoder == nil {
            
            m_geocoder = CLGeocoder()
        }
        
        m_geocoder.geocodeAddressString(addressStr) { (_plcaeMarks, _error) in
            
            if _error != nil {
                
                print("\(_error?.localizedDescription)")
            }
            
            if let placeMarks = _plcaeMarks {
            
                let placeMark = placeMarks[0]
                
                //取得回傳值後,將回傳值顯示在地圖上,使用泡泡筐(MKAnnotation)來顯示
                let annotation = MKPointAnnotation()
                annotation.title = self.addressStr
                annotation.subtitle = self.annotationSubtitle
                
                if let location =  placeMark.location {
                    
                    annotation.coordinate = location.coordinate
                    
                    self.m_mapView.showAnnotations([annotation], animated: true)
                    self.m_mapView.selectAnnotation(annotation, animated: true)
                }
            
            }
            
        }
        
    }
    
    
//MARK: - MKMapView Delegate
//--------------------------
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView_id:String = "VIEW_ID"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationView_id) as? MKPinAnnotationView
        
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationView_id)
            annotationView!.canShowCallout = true
        }
        
        let letftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        letftIconView.image = UIImage(named: self.imgName)
        letftIconView.contentMode = .ScaleAspectFill
        annotationView?.leftCalloutAccessoryView = letftIconView
        
        return annotationView
    }
    
    
//MARK: - CLLocationManager  Delegate
//-----------------------------------
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        m_latitude = newLocation.coordinate.latitude
        m_longitude = newLocation.coordinate.longitude
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        m_heading = newHeading.trueHeading
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("定位服務失敗")
    }

//MARK: - onBarBtItemAction
//-------------------------
    func onBarBtItemAction(sender:UIBarButtonItem) {
        
        //判斷目前裝置版本
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0 {
            /*要在 info.plist 增加:
             1.NSLocationWhenInUseUsageDescriotion (type:String, value:YES)
             2.NSLocationAlwaysUsageDescription (type:String, value:YES)
             */
            m_locationManeger?.requestAlwaysAuthorization() //認證要求
            //m_locationManeger?.requestWhenInUseAuthorization() //認證要求
        }
        
        
        //定位機制開始
        m_locationManeger?.startUpdatingHeading()
        m_locationManeger?.startUpdatingLocation()
        
        
        //地圖顯示位置,範圍
        m_mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        m_mapCnter = CLLocationCoordinate2D(latitude: 24.147872, longitude: 120.637580)
        m_mapView.setCenterCoordinate(m_mapCnter!, animated: true)
        m_mapRegion = MKCoordinateRegion(center: m_mapCnter!, span: m_mapSpan!)
        m_mapView.setRegion(m_mapRegion!, animated: true)
        m_mapView.userTrackingMode = MKUserTrackingMode.FollowWithHeading
        m_mapView.showsUserLocation = true
        
    }
   

}
