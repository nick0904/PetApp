
//動物之家地址: 臺北市內湖區潭美街 852 號

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //地圖
    var m_mapView:MKMapView!
    var geocoder:CLGeocoder!
    var m_mapRegion:MKCoordinateRegion?
    var m_mapSpan:MKCoordinateSpan?
    var addressStr:String = ""
    var annotationSubtitle:String = ""
    var imgName:String = ""
    var annotation:MKPointAnnotation!
    var finalLocation:CLLocationCoordinate2D!
    
    //定位
    var m_locationManeger:CLLocationManager? //定位管理者
    
    //位置查詢
    var m_geocoder:CLGeocoder! //世界座標地址查詢
    
//MARK: - refreshWithFrame
//------------------------
    func refreshWithFrame(frame:CGRect,navH:CGFloat) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "我的位置", style: .Plain, target: self, action: #selector(MapViewController.onBarBtItemAction(_:)))
        
        let openBt = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width/2, height: navH - UIApplication.sharedApplication().statusBarFrame.size.height))
        openBt.setTitle("開啟導航", forState: .Normal)
        openBt.setTitleColor(UIColor.blueColor(), forState: .Normal)
        openBt.addTarget(self, action: #selector(MapViewController.showAlert), forControlEvents: .TouchUpInside)
        self.navigationItem.titleView = openBt
        
        
        //m_locationManeger
        self.m_locationManeger = CLLocationManager()
        //判斷目前裝置版本
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0 {
            /*要在 info.plist 增加:
             1.NSLocationWhenInUseUsageDescriotion (type:String, value:YES)
             2.NSLocationAlwaysUsageDescription (type:String, value:YES)
             */
            //m_locationManeger?.requestAlwaysAuthorization() //認證要求
            m_locationManeger?.requestWhenInUseAuthorization() //認證要求
        }
        
        //map
        m_mapView = MKMapView(frame: CGRect(x: 0, y: navH, width: frame.size.width, height: frame.size.height - navH))
        m_mapView.delegate = self
        self.view.addSubview(m_mapView)

        //m_geocoder
        m_geocoder = CLGeocoder()
        
        //annotation
        self.annotation = MKPointAnnotation()
        
        //finalLocation
        finalLocation = CLLocationCoordinate2D()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if m_geocoder == nil {
            
            m_geocoder = CLGeocoder()
        }
        
        //將地址轉換成經緯度
        m_geocoder.geocodeAddressString(addressStr) { (_plcaeMarks, _error) in
            
            if _error != nil {
                
                print("\(_error?.localizedDescription)")
            }
            
            if let placeMarks = _plcaeMarks {
            
                let placeMark = placeMarks[0]
                
                //取得回傳值後,將回傳值顯示在地圖上,使用泡泡筐(MKAnnotation)來顯示
                self.annotation.title = self.addressStr
                self.annotation.subtitle = self.annotationSubtitle
                
                if let location =  placeMark.location {
                    
                    self.annotation.coordinate = location.coordinate
                    self.finalLocation = location.coordinate
                    
                    self.m_mapView.showAnnotations([self.annotation], animated: true)
                    self.m_mapView.selectAnnotation(self.annotation, animated: true)
                }
            
            }
            
        }
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        m_mapView.removeAnnotation(annotation)
    }
    

//MARK: - onBarBtItemAction顯示使用者所在位置
//----------------------------------------
    func onBarBtItemAction(sender:UIBarButtonItem) {
        
        if let locationManager = self.m_locationManeger {
            
            //定位機制開始
            locationManager.startUpdatingHeading()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //地圖顯示位置,範圍
            let center = CLLocationCoordinate2DMake(locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude)
            m_mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            m_mapView.setCenterCoordinate(center, animated: true)
            m_mapRegion = MKCoordinateRegion(center: center, span: m_mapSpan!)
            m_mapView.setRegion(m_mapRegion!, animated: true)
            m_mapView.userTrackingMode = MKUserTrackingMode.FollowWithHeading
            m_mapView.showsUserLocation = true
            m_mapView.userLocation.title = "您的目前位置"
    
            self.showDirection()
        }
        
    }
    
    var directionRequest:MKDirectionsRequest!
    var m_route:MKRoute!
//MARK: - showDirection
//---------------------
    func showDirection() {
        
        directionRequest = MKDirectionsRequest()
        
        //路徑起點
        let beginCoordinate = CLLocationCoordinate2D(latitude: m_locationManeger!.location!.coordinate.latitude, longitude: m_locationManeger!.location!.coordinate.longitude)
        let beginMark = MKPlacemark(coordinate: beginCoordinate, addressDictionary: nil)
        directionRequest.source = MKMapItem(placemark: beginMark)
        
        //路徑終點
        let finalCoordinate = CLLocationCoordinate2DMake( CLLocationDegrees(self.finalLocation.latitude), CLLocationDegrees(self.finalLocation.longitude))
        let finalMark = MKPlacemark(coordinate: finalCoordinate, addressDictionary: nil)
        directionRequest.destination = MKMapItem(placemark: finalMark)
        
        //交通工具
        directionRequest.transportType = .Automobile
        
        //方位計算
        let directions = MKDirections(request: directionRequest)
        directions.calculateDirectionsWithCompletionHandler { (routeResponse, routeError) in
            
            if routeError != nil {
                
                print("routeError:\(routeError?.localizedDescription)")
            }
            
            //設定路線
            self.m_route = routeResponse?.routes[0] as MKRoute!
            
            //設定 map 視圖自動符合導航路徑範圍
            let rect = self.m_route!.polyline.boundingMapRect
            self.m_mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }

    
//MARK: - openMap
//---------------
    func openMap() {
        
        //路徑起點
        let beginCoordinate = CLLocationCoordinate2D(latitude: m_locationManeger!.location!.coordinate.latitude, longitude: m_locationManeger!.location!.coordinate.longitude)
        let beginMark = MKPlacemark(coordinate: beginCoordinate, addressDictionary: nil)
        let beginItem = MKMapItem(placemark: beginMark)
        beginItem.name = "您的目前位置"
        
        //路徑終點
        let finalCoordinate = CLLocationCoordinate2DMake( CLLocationDegrees(self.finalLocation.latitude), CLLocationDegrees(self.finalLocation.longitude))
        let finalMark = MKPlacemark(coordinate: finalCoordinate, addressDictionary: nil)
        let finalItem = MKMapItem(placemark: finalMark)
        finalItem.name = self.addressStr
        
        let theRoute = [beginItem,finalItem]
        
        let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
        
        //開啟地圖導航
        MKMapItem.openMapsWithItems(theRoute, launchOptions: options)
    }
    
//MARK: - showAlert
//-----------------
    func showAlert() {
        
        let alert = UIAlertController(title:"導航模式", message: "您要開啟地圖進行路線導航嗎 ?", preferredStyle:.Alert)
        //apple Map
        alert.addAction(UIAlertAction(title: "開啟Apple地圖", style: .Default, handler: { (appleAction) in
            
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0/10.0 * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue(), {
                
                self.openMap()
            })
            
        }))
        
        //Google Map
        alert.addAction(UIAlertAction(title: "開啟Google地圖", style: .Default, handler: { (googleAction) in
            
            
            let urlString = NSURL(string: String(format: "comgooglemaps://?daddr=%f,%f&saddr=%f,%f&mrsp=0&ht=it&ftr=0",CLLocationDegrees(self.finalLocation.latitude),CLLocationDegrees(self.finalLocation.longitude),self.m_locationManeger!.location!.coordinate.latitude,self.m_locationManeger!.location!.coordinate.longitude))
            
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0/10.0 * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue(), {
                
                UIApplication.sharedApplication().openURL(urlString!)
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .Destructive, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
}//end class
