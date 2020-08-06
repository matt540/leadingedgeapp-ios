//
//  Location_VC.swift
//  SurfBoard
//
//  Created by HariKrishna Kundariya on 20/12/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import MapKit

class Location_VC: BaseViewController, MGMapViewDelegate, MGMapDrawViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var isFromMenu:Bool = false
    var isfromSearch:Bool = false
    var isCurrentLoc:Bool = true
    var SearchLocLat:Double = 0.0
    var SearchLocLng:Double = 0.0
    var arrData:NSMutableArray = []
    
    var strLocName:String = ""
    
    var dictCurrentLocation: NSMutableDictionary = [:]
    var Range:String = "25"
    
    var picker:UIPickerView!
    var numbers = ["25","50","75","100"]
    
    var locationManager : CLLocationManager!
    var selectedAnn : MGMapAnnotation!
    var location : CLLocation!
    
    @IBOutlet var MapviewMain:MGMapView!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var txtRange: UITextField!
    @IBOutlet var mapViewmainHeight: NSLayoutConstraint!
    
    @IBOutlet var lblYourLocTITLE: UILabel!
    @IBOutlet var lblRangeTITLE: UILabel!
    
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isFromMenu == true)
        {
            self.navigationController?.isNavigationBarHidden = false
            AppDelegate.shared().setupNavigationBar()
            setLeftBarBackItem()
            self.title = "Location Finder"
            setTranspertNavigation()
        }
        else
        {
            self.navigationController?.isNavigationBarHidden = false
            AppDelegate.shared().setupNavigationBar()
            self.title = "Location Finder"
            setTranspertNavigation()
        }
        
        self.picker = UIPickerView()
        self.picker.delegate = self
        self.picker.dataSource = self
        self.txtRange.inputView = self.picker
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClicked))]
        numberToolbar.sizeToFit()
        self.txtRange.inputAccessoryView = numberToolbar
        
        //Location
        if CLLocationManager.locationServicesEnabled()
        {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            let authorizationStatus = CLLocationManager.authorizationStatus()
            if(authorizationStatus == .denied || authorizationStatus == .notDetermined || authorizationStatus == .restricted)
            {
                let alert = UIAlertController(title: "Allow Location Access", message: "Link Affiliate needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                print(authorizationStatus)
            }
        }
        //Location Comp
        
        MapviewMain.delegate = self
        MapviewMain.baseInit()
        MapviewMain.zoomAndFitAnnotations()
        addMapAnnotations()
        
        print("Current Lat :\(AppDelegate.shared().latitude)")
        print("Current Long :\(AppDelegate.shared().longitude)")
        
        //Location from latitude & longitude with Extension
        let location = CLLocation(latitude: AppDelegate.shared().latitude, longitude: AppDelegate.shared().longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            self.txtSearch.text = city + ", " + country
        }
        
        self.mapViewmainHeight.constant = self.view.frame.size.height
        self.view.updateConstraintsIfNeeded()
        
        Search_Location_API()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(AppDelegate.shared().isFromBooking == true){
            AppDelegate.shared().isFromBooking  = false
            
            self.tabBarController?.selectedIndex = 2
        }
        
        self.setupLang()
        
    }
    
    func setupLang(){
        
        let lang = DGLocalization.sharedInstance.getCurrentLanguage()
        
        if (lang.languageCode == "en"){
            print("Selected Lang english")
            self.SetupData()
        }
        else if (lang.languageCode == "es"){
            print("Selected Lang Spanish")
            self.SetupData()
        }
        else if (lang.languageCode == "de"){
            print("Selected Lang German")
            self.SetupData()
        }
        else if (lang.languageCode == "fr"){
            print("Selected Lang French")
            self.SetupData()
        }
        else if (lang.languageCode == "it"){
            print("Selected Lang Italian")
            self.SetupData()
        }
        else{
            
        }
    }
    
    func SetupData(){
        
        self.title = "LOCATION_TITLE".localize
        
        self.tabBarController?.tabBar.items![0].title = "TABBAR_ITEM_TITLE_0".localize
        self.tabBarController?.tabBar.items![1].title = "TABBAR_ITEM_TITLE_1".localize
        self.tabBarController?.tabBar.items![2].title = "TABBAR_ITEM_TITLE_2".localize
        self.tabBarController?.tabBar.items![3].title = "TABBAR_ITEM_TITLE_3".localize
        self.tabBarController?.tabBar.items![4].title = "TABBAR_ITEM_TITLE_4".localize

        self.txtRange.text = "25 " + "MILES".localize
        self.lblYourLocTITLE.text = "YOUR_LOCATION_TITLE".localize
        self.lblRangeTITLE.text = "RANGE_TITLE".localize
        self.txtSearch.placeholder = "YOUR_LOCATION_PLACEHOLDER".localize
        
    }
    
    
    //MARK: - doneClicked method
    @objc func doneClicked() -> Void
    {
        self.view.endEditing(true)
        let currentLocation:String = self.txtSearch.text!
        
        getLocation(from: currentLocation) { location in
            print(location as Any)
            print("Location is", location.debugDescription)
            print("Location lat is", location?.latitude as Any)
            print("Location long is", location?.longitude as Any)
            self.SearchLocLat = location?.latitude ?? 0.0
            self.SearchLocLng = location?.longitude ?? 0.0
            self.isfromSearch = true
            
            var coords: CLLocationCoordinate2D
            var region = MKCoordinateRegion()
            var span = MKCoordinateSpan()
            
            span.latitudeDelta = CLLocationDegrees(3)
            span.longitudeDelta = CLLocationDegrees(3)
            region.span = span
            
            coords = CLLocationCoordinate2DMake(CLLocationDegrees(self.SearchLocLat), CLLocationDegrees(self.SearchLocLng))
            region.center = coords
            
            self.MapviewMain.mapView?.setCenter(coords, animated: true)
            self.MapviewMain.setRegion(region, animated: true)
            self.MapviewMain.regionThatFits(region)
            
            if CLLocationCoordinate2DIsValid(coords) {
                self.Search_Location_API()
            }
        }
    }
    
    //MARK: - UIPickerviewDelegate and Datasource methods -
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return SAFESTRING(str: numbers[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.txtRange.text = "\(numbers[row]) " + "MILES".localize
        self.Range = "\(numbers[row])"
    }
    
    
    //MARK: - UITextfield Delegate Method -
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        self.isCurrentLoc = false
        if self.txtSearch.text == ""
        {
            displayAlert(APPNAME, andMessage: "ERROR_ENTER_KEYWORD".localize)
        }
        else
        {
            print(self.txtSearch.text!)
            getLocation(from: self.txtSearch.text!) { location in
                print(location as Any)
                print("Location is", location.debugDescription)
                print("Location lat is", location?.latitude as Any)
                print("Location long is", location?.longitude as Any)
                self.SearchLocLat = location?.latitude ?? 0.0
                self.SearchLocLng = location?.longitude ?? 0.0
                self.isfromSearch = true
                
                var coords: CLLocationCoordinate2D
                var region = MKCoordinateRegion()
                var span = MKCoordinateSpan()
                
                span.latitudeDelta = CLLocationDegrees(3)
                span.longitudeDelta = CLLocationDegrees(3)
                region.span = span
                
                coords = CLLocationCoordinate2DMake(CLLocationDegrees(self.SearchLocLat), CLLocationDegrees(self.SearchLocLng))
                region.center = coords
                
                self.MapviewMain.mapView?.setCenter(coords, animated: true)
                self.MapviewMain.setRegion(region, animated: true)
                self.MapviewMain.regionThatFits(region)
                
                if CLLocationCoordinate2DIsValid(coords) {
                    self.Search_Location_API()
                }
            }
        }
        return true
    }
    
    
    //MARK:- btnLocateMeAction METHODS
    @IBAction func btnLocateMeAction(_ sender: Any) {
        
        self.isCurrentLoc = true
        
        var coords: CLLocationCoordinate2D
        var region = MKCoordinateRegion()
        var span = MKCoordinateSpan()
        let annotations: NSMutableArray = []
        
        span.latitudeDelta = CLLocationDegrees(3)
        span.longitudeDelta = CLLocationDegrees(3)
        region.span = span
        
        coords = CLLocationCoordinate2DMake(CLLocationDegrees(AppDelegate.shared().latitude), CLLocationDegrees(AppDelegate.shared().longitude))
        region.center = coords
        
        self.MapviewMain.mapView?.setCenter(coords, animated: true)
        self.MapviewMain.setRegion(region, animated: true)
        self.MapviewMain.regionThatFits(region)
        
        if CLLocationCoordinate2DIsValid(coords) {
            let ann = MGMapAnnotation(coordinate: coords, name:"", description:"" )
            
            let dict : NSMutableDictionary = [:]
            dict.setValue(12451245, forKey: "id")
            dict.setValue(AppDelegate.shared().latitude, forKey: "latitude")
            dict.setValue(AppDelegate.shared().longitude, forKey: "longitude")
            ann!.object = dict
            annotations.add(ann!)
            
            self.MapviewMain.setMapData(annotations)
            self.zoomtoFitMapAnnotations(self.MapviewMain)
            self.isCurrentLoc = false
        }
        
    }
    
    //MARK:- MAP DELEGATE METHODS
    func mgMapView(_ mapView: MGMapView!, didSelect mapAnnotation: MGMapAnnotation!) {
        
    }
    
    func mgMapView(_ mapView: MGMapView!, didAccessoryTapped mapAnnotation: MGMapAnnotation!) {
        
    }
    
    func mgMapView(_ mapView: MGMapView!, didCreateMKPinAnnotationView mKPinAnnotationView: MKPinAnnotationView!, viewFor annotation: MKAnnotation!) {
        
        let ann = annotation as? MGMapAnnotation
        let dict = ann?.object as? NSMutableDictionary
        
        mKPinAnnotationView.canShowCallout = true
        //mKPinAnnotationView.animatesDrop = NO;
        let rightButton = UIButton(type: .detailDisclosure)
        rightButton.addTarget(nil, action: #selector(btnTapAccessory(_:)), for: .touchUpInside)
        rightButton.tag = dict!["id"] as? Int ?? 0
        rightButton.accessibilityLabel = dict!["name"] as? String ?? ""
        
        let Desc = dict!["description"] as? String ?? ""
        if(Desc == "You're Here")
        {
            mKPinAnnotationView.image = UIImage(named: "RedPin")
        }
        else
        {
            mKPinAnnotationView.image = UIImage(named: "MapPin")
        }
        
        mKPinAnnotationView.rightCalloutAccessoryView = rightButton;
        
    }
    
    func mgDrawView(_ drawView: MGDrawView!, touchesMoved touch: UITouch!) {
        
    }
    
    func mgDrawView(_ drawView: MGDrawView!, touchesEnded touch: UITouch!) {
        
    }
    
    func mgDrawView(_ drawView: MGDrawView!, touchesBegan touch: UITouch!) {
        
    }
    
    
    //MARK:- zoomtoFitMapAnnotations METHOD
    func zoomtoFitMapAnnotations(_ mapView: MGMapView?) {
        
        var coords: CLLocationCoordinate2D
        var region = MKCoordinateRegion()
        var span = MKCoordinateSpan()
        var lat: Double = 0.0
        var lng: Double = 0.0
        
        if(self.isCurrentLoc == true)
        {
            lat = AppDelegate.shared().latitude
            lng = AppDelegate.shared().longitude
        }
        else if(isfromSearch == true)
        {
            self.isfromSearch = false
            lat = self.SearchLocLat
            lng = self.SearchLocLng
        }
        else
        {
            lat = 41.148499
            lng = -73.493698
        }
        
        coords = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lng))
        span.latitudeDelta = CLLocationDegrees(3)
        span.longitudeDelta = CLLocationDegrees(3)
        region.span = span
        region.center = coords
        
        //MapviewMain.mapView?.setCenter(selectedAnn.coordinate, animated: true)
        MapviewMain.mapView?.setCenter(coords, animated: true)
        MapviewMain.setRegion(region, animated: true)
        MapviewMain.regionThatFits(region)
    }
    
    
    //MARK:- locationManager METHOD
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        MapviewMain.mapView?.setCenter(locations[0].coordinate, animated: true)
        let viewRegion = MKCoordinateRegion(center: locations[0].coordinate, latitudinalMeters: CLLocationDistance(0.3 * METES_PER_MILE), longitudinalMeters: CLLocationDistance(0.3 * METES_PER_MILE))
        let adjustedRegion = MapviewMain.mapView?.regionThatFits(viewRegion)
        MapviewMain.mapView?.setRegion(adjustedRegion!, animated: true)
    }
    
    
    //MARK:- EXTRA METHOD
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location?.coordinate else {
                    if((error) != nil){
                        print("Error : ", error!.localizedDescription)
                        displayAlert(APPNAME, andMessage: "ERROR_LOC_NOT_FOUND".localize)
                    }
                    return
            }
            completion(location)
        }
    }
    
    //MARK: - addMapAnnotations Method
    func addMapAnnotations() {
        let annotations: NSMutableArray = []
        
        //for dictBusiness in favoriteList {
        var coords: CLLocationCoordinate2D
        var strLat:String!
        var strLong:String!
        
        if(self.isCurrentLoc == true)
        {
            strLat =  String(AppDelegate.shared().latitude)
            strLong = String(AppDelegate.shared().longitude)
        }
        else
        {
            strLat =  "41.148499"//dictBusiness["lat"] as? String
            strLong = "-73.493698"//dictBusiness["long"] as? String
        }
        
        coords = CLLocationCoordinate2DMake(CLLocationDegrees(Double(strLat) ?? 0.0), CLLocationDegrees(Double(strLong) ?? 0.0))
        
        if CLLocationCoordinate2DIsValid(coords) {
            let ann = MGMapAnnotation(coordinate: coords, name:"", description:"" )
            
            self.dictCurrentLocation["description"] = "You're Here"
            self.dictCurrentLocation["name"] = ""
            self.dictCurrentLocation["id"] = "0"
            self.dictCurrentLocation["location"] = ""
            if(self.isfromSearch == true)
            {
                self.dictCurrentLocation["latitude"] = String(self.SearchLocLat)
                self.dictCurrentLocation["longitude"] = String(self.SearchLocLng)
            }
            else
            {
                self.dictCurrentLocation["latitude"] = String(AppDelegate.shared().latitude)
                self.dictCurrentLocation["longitude"] = String(AppDelegate.shared().longitude)
            }
            
            ann!.object = self.dictCurrentLocation
            
            annotations.add(ann!)
            selectedAnn = ann
            //}
            
            MapviewMain.setMapData(annotations)
            zoomtoFitMapAnnotations(MapviewMain)
        }
        
    }
    
    
    //MARK: - btnTapAccessory Method
    @IBAction func btnTapAccessory(_ sender: Any) {
        
        let btn = sender as? UIButton
        let PinID = (btn?.tag)
        
        self.strLocName = (btn?.accessibilityLabel)! 
        
        if(PinID == 0 || PinID == 12451245)
        {
            displayAlert(APPNAME, andMessage: "ERROR_SOMETHING".localize)
        }
        else
        {
            self.CHECK_BOOKING(BtnID: PinID!)
        }
    }
    
    
    //MARK: - Location API Calls
    func Search_Location_API() {
        
        let url = API.BASE_URL + API.SEARCH_LOCATION
        var param : [String:String] = ["":""]
        if(self.isCurrentLoc == true)
        {
            param = ["latitude" : "\(AppDelegate.shared().latitude)",
                "longitude" : "\(AppDelegate.shared().longitude)","range":Range]
        }
        else if(self.isfromSearch == true)
        {
            param = ["latitude" : String(self.SearchLocLat),
                     "longitude" : String(self.SearchLocLng),"range":Range]
        }
        else
        {
            param = ["latitude":"41.148499","longitude":"-73.493698","range":Range]
        }
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
        ]
        
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: header).response { (response) in
                AppDelegate.shared().HideSpinnerView()
                do
                {
                    let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    if dict?.count==0 || dict == nil
                    {
                        displayAlert(APPNAME, andMessage: "ERROR_RESPONSE".localize)
                    }
                    else
                    {
                        let status = dict?.value(forKeyPath: "status") as? String ?? ""
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: dict?.value(forKeyPath: "message") as! String)
                        }
                        else
                        {
                            self.arrData = (dict?.object(forKey: "data") as? NSMutableArray)!
                            if (self.arrData.count == 0)
                            {
                                displayAlert(APPNAME, andMessage: "ERROR_NEAR_LOC_NOT_FOUND".localize)
                            }
                            else
                            {
                                
                            }
                            self.dictCurrentLocation["description"] = "You're Here"
                            self.dictCurrentLocation["name"] = ""
                            self.dictCurrentLocation["id"] = "0"
                            self.dictCurrentLocation["location"] = ""
                            if(self.isfromSearch == true)
                            {
                                self.dictCurrentLocation["latitude"] = "\(self.SearchLocLat)"
                                self.dictCurrentLocation["longitude"] = "\(self.SearchLocLng)"
                            }
                            else
                            {
                                self.dictCurrentLocation["latitude"] = "\(AppDelegate.shared().latitude)"//"41.148499"
                                self.dictCurrentLocation["longitude"] = "\(AppDelegate.shared().longitude)"//"-73.493698"
                            }
                            
                            self.arrData.add(self.dictCurrentLocation)
                            print(self.arrData)
                            let annotations: NSMutableArray = []
                            for dictBusiness in self.arrData {
                                
                                var coords: CLLocationCoordinate2D
                                let dictBusiness1 = dictBusiness as? NSMutableDictionary
                                
                                let strLat = dictBusiness1!["latitude"] as? String
                                let strLong = dictBusiness1!["longitude"] as? String
                                coords = CLLocationCoordinate2DMake(CLLocationDegrees(Double(strLat ?? "") ?? 0.0), CLLocationDegrees(Double(strLong ?? "") ?? 0.0))
                                
                                if CLLocationCoordinate2DIsValid(coords) {
                                    let ann = MGMapAnnotation(coordinate: coords, name: dictBusiness1!["name"] as? String, description: dictBusiness1!["description"] as? String)
                                    
                                    ann!.object = dictBusiness1!
                                    annotations.add(ann!)
                                }
                            }
                            
                            self.MapviewMain.setMapData(annotations)
                            self.zoomtoFitMapAnnotations(self.MapviewMain)
                        }
                    }
                }
            }
        }
        else
        {
            displayAlert(APPNAME, andMessage: "ERROR_NETWORK".localize)
        }
    }
    
    func CHECK_BOOKING(BtnID : Int) {
        
        let url = API.BASE_URL + API.CHECK_BOOKING_STATUS
        let param : [String:String] = ["location" : "\(BtnID)"]
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
        ]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: header).response { (response) in
                AppDelegate.shared().HideSpinnerView()
                do
                {
                    let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    if dict?.count==0 || dict == nil
                    {
                        displayAlert(APPNAME, andMessage: MSG.NO_RESPONSE)
                    }
                    else
                    {
                        print(dict!)
                        let status = dict?.value(forKeyPath: "status") as? String ?? ""
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String)!)
                        }
                        else
                        {
                            print(dict!)
                            let dictData = dict?.value(forKey: "data") as? NSMutableDictionary
                            let Check_Flag = dictData?.value(forKey: "allowed") as? Bool
                            
                            if(Check_Flag == true)
                            {
                                var DictForPalce:NSMutableDictionary = [:]
                                for dict in self.arrData
                                {
                                    let dictdata = dict as? NSMutableDictionary
                                    let id = dictdata?.value(forKey: "id") as? Int
                                    if(id == BtnID)
                                    {
                                        DictForPalce = dictdata!
                                        print(dictdata!)
                                        let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Session_Inner_VC") as! Session_Inner_VC
                                        nextNavVc.DictData = DictForPalce
                                        self.navigationController?.pushViewController(nextNavVc, animated: true)
                                    }
                                    else
                                    {
                                        
                                    }
                                }
                            }
                            else
                            {
//                               displayAlert(APPNAME, andMessage: "Currently Booking Not Available For This Location.")
                                
                                let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "AffiliatePopup_VC") as! AffiliatePopup_VC
                                popupVC.strLoc = self.strLocName
                                self.view.addSubview(popupVC.view)
                                self.addChild(popupVC)
                            }
                        }
                    }
                }
            }
        }
        else
        {
            displayAlert(APPNAME, andMessage: MSG.NO_NETWORK)
        }
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
