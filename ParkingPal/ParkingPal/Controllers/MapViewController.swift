//
//  ViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 3/5/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import Alamofire
import ArcGIS
import CoreData
import SwiftyJSON
import UIKit

class MapViewController: UIViewController, MapFilterDelegate{

    @IBOutlet weak var identifyContainer: UIView!
    @IBOutlet weak var identifyBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: AGSMapView!
    @IBOutlet weak var menuConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuBlurView: UIVisualEffectView!
    @IBOutlet weak var menuView: UIView!
    
    //- constants
    private let parkingPalAPIUrl = "https://parkingpalapi.azurewebsites.net/"
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let graphicsOverlay = AGSGraphicsOverlay()
    private let spatialReference = AGSSpatialReference(wkid: 102100)
    
    //- variable properties
    private var currentMapFilter : MapFilter? = nil
    private var currentLocations: [Location] = [Location](){
        didSet{
            updateMap()
        }
    }
    private var selectedLocation: Location? = nil
    private var identifyViewController: IdentifyViewController? = nil
    private var isMenuOpen = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        identifyBottomConstraint.constant = -128
        
        menuBlurView.layer.cornerRadius = 15
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.8
        menuView.layer.shadowOffset = CGSize(width: 5, height: 0)
        menuConstraint.constant = -175
        
        //- set initial map location
        let basemap = AGSArcGISVectorTiledLayer(url: URL(string: "https://basemaps.arcgis.com/arcgis/rest/services/World_Basemap_v2/VectorTileServer")!)
        
        mapView?.map = AGSMap(spatialReference: spatialReference!)
        mapView!.map!.basemap = AGSBasemap(baseLayer: basemap)
        
        let agsPoint = AGSPointMake(-117.180275, 32.74428, AGSSpatialReference(wkid: 4326))
        
        let initialViewpoint = AGSViewpoint(center: agsPoint, scale: 100000)
        mapView?.setViewpoint(initialViewpoint)
        
        mapView.graphicsOverlays.add(graphicsOverlay)
        
        mapView.touchDelegate = self
        mapView.viewpointChangedHandler = respondToEnvChange
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "goToFilter"{
            let destination = segue.destination as! MapFilterViewController
            
            destination.mapFilter = currentMapFilter
            destination.delegate = self
        }
        else if segue.identifier! == "goToDetails" {
            let destination = segue.destination as! ParkingDetailsViewController
            destination.currentLocation = selectedLocation
        }
        else if segue.identifier! == "embedIdentify" {
            identifyViewController = segue.destination as? IdentifyViewController
            identifyViewController?.delegate = self
        }
    }
    
    func closeMenu(){
            //close the menu
            while self.menuConstraint.constant > -175{
                UIView.animate(withDuration: 0.2) {
                    self.menuConstraint.constant -= 10
                    self.view.layoutIfNeeded()
                }
            }
            
            isMenuOpen = false
    }
    
    func openMenu(){
        //open menu
        while self.menuConstraint.constant < 0{
            UIView.animate(withDuration: 0.2) {
                self.menuConstraint.constant += 10
                self.view.layoutIfNeeded()
            }
        }
        
        isMenuOpen = true
    }

    @IBAction func menuBtnTouched(_ sender: Any) {
        if isMenuOpen{
            closeMenu()
        }
        else{
            openMenu()
        }
    }
    
    
    //MARK: MapFilterDelegate Method
    //*******************************************
    
    func applyFilter(filter: MapFilter?) {
        currentMapFilter = filter
    }
    
    
    
    
}


//MARK: Identify Delegate and Methods
//**************************************************

private typealias MapControllerIdentifyView = MapViewController
extension MapControllerIdentifyView : IdentifyViewDelegate{
    
    func closeIdentify() {
        while self.identifyBottomConstraint.constant > -128{
            UIView.animate(withDuration: 0.2, animations: {
                self.identifyBottomConstraint.constant -= 10;
                self.view.layoutIfNeeded()
            })
        }
        //identifyContainer.isHidden = true
    }
    
    func goToLocation() {
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    func setLocation(){
        performSegue(withIdentifier: "goToMapSetLocation", sender: self)
    }
    
    func loadIdentify(){
        identifyViewController?.addressLabel.text = selectedLocation?.address
        identifyViewController?.titleButton.setTitle(selectedLocation?.title, for: .normal)
        
        while self.identifyBottomConstraint.constant < 0{
            UIView.animate(withDuration: 0.2, animations: {
                self.identifyBottomConstraint.constant += 10;
                self.view.layoutIfNeeded()
            })
        }
        //identifyContainer.isHidden = false
    }
    
}



//MARK: AGSGraphics and AGSMap method implementations
//***************************************************
private typealias MapViewControllerArcGIS = MapViewController
extension MapViewControllerArcGIS : AGSGeoViewTouchDelegate {
    
    func initGraphicsLayer(){
        
    }
    
    // Map Viewpoint changed
    func respondToEnvChange() {
        // get data within current map extent
        if(mapView?.isNavigating == false){
            //print(theString)
            //getAllParkingLocations()
            getParkingLocations(xmin: (mapView?.visibleArea?.extent.xMin)!, xmax: (mapView?.visibleArea?.extent.xMax)!, ymin: (mapView?.visibleArea?.extent.yMin)!, ymax: (mapView?.visibleArea?.extent.yMax)!, wkid: 4326)
            
        }
    }
    
    func createSimpleMarkerSymbol(for location: Location){
        let symbol: AGSSimpleMarkerSymbol = AGSSimpleMarkerSymbol(style: .circle, color: .blue, size: 12)
        
        let point = AGSPointMake(location.longitude, location.latitude, AGSSpatialReference(wkid: 4326))
        //print("x: \(point.x) y: \(point.y)")
        let graphic = AGSGraphic(geometry: point, symbol: symbol, attributes: ["location" : location])
        
        graphicsOverlay.graphics.add(graphic)
    }
    
    func updateMap(){
        graphicsOverlay.graphics.removeAllObjects()
        
        currentLocations.forEach {
            location in
            
            createSimpleMarkerSymbol(for: location)
        }
    }
    
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        
        mapView.identify(graphicsOverlay, screenPoint: screenPoint, tolerance: 12, returnPopupsOnly: false) {
            (result) in
            if let error = result.error {
                print("Error identifying map screen tap \(error)")
            }
            else{
                if result.graphics.count > 0{
                    self.selectedLocation = result.graphics[0].attributes["location"] as? Location
                    self.loadIdentify()
                    //self.performSegue(withIdentifier: "goToDetails", sender: self)
                    print("Location tapped: \(self.selectedLocation!.title)")
                }
                
                self.closeMenu()
            }
        }
    }
    
}


//MARK ParkingLocation REST Request
private typealias MapViewControllerRest = MapViewController
extension MapViewControllerRest{
    
    func getAllParkingLocations() {
        var locations: [Location] = []
        
        Alamofire.request(parkingPalAPIUrl + "locations", method: .get, parameters: nil).responseJSON {
            (response) in
            if response.result.isSuccess{
                
                //- populate all locations returned from the API request
                let locationArray = JSON(response.result.value!).array!
                locationArray.forEach {
                    (json: JSON) in
                    locations.append(self.parkingLocation(from: json))
                }
                
                self.currentLocations = locations
            }
            else{
                print("Error requesting locations \(response.error!)")
            }
        }
        
    }
    
    func getParkingLocations(xmin: Double, xmax: Double, ymin: Double, ymax:Double, wkid: Int){
        var locations: [Location] = []
        
        let minPoint = AGSPointMakeWebMercator(xmin, ymin).toCLLocationCoordinate2D()
        let maxPoint = AGSPointMakeWebMercator(xmax, ymax).toCLLocationCoordinate2D()
        
        let parameters: [String : Any] = [
            "xmin" : minPoint.longitude,
            "xmax" : maxPoint.longitude,
            "ymin" : minPoint.latitude,
            "ymax" : maxPoint.latitude,
            "wkid" : wkid
        ]
        let headers = ["Content-type": "application/json"]
        
        Alamofire.request(parkingPalAPIUrl + "locations/envelope", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            (response) in
            if response.result.isSuccess{
                
                //- populate all locations returned from the API request
                let locationArray = JSON(response.result.value!).array!
                locationArray.forEach {
                    (json: JSON) in
                    locations.append(self.parkingLocation(from: json))
                }
                
                self.currentLocations = locations
                
                print("# Visible locations: \(locations.count)")
            }
            else{
                print("Error requesting locations \(response.error!)")
            }
        }
    }
    
    func parkingLocation(from json: JSON) -> Location{
        let location: Location = Location(context: context)
        
        location.address = json["ad"].string
        location.latitude = json["lt"].double!
        location.longitude = json["lg"].double!
        location.parkingType = json["pt"].int32!
        location.detailSummary = json["ds"].string
        location.title = json["tt"].string
        location.website = json["ws"].string
        
        return location
    }
}



