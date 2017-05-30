//
//  Map.swift
//  Mapa-UFG
//
//  Created by tulio ferreira hermano on 21/05/17.
//  Copyright © 2017 Tiago Hermano. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class Map: GMSMapView {
    var mapView: GMSMapView!
    var mapCamera: GMSCameraPosition!
    
//    static func setInitialMap() -> UIView {
//        
//        let mapCamera = GMSCameraPosition.camera(withLatitude: -16.6021102, longitude: -49.2656253, zoom: 16)
//        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
//        self.mapView.isMyLocationEnabled = true
//        
//        self.mapView.settings.compassButton = true
//        self.mapView.isMyLocationEnabled = true
//        mapView.isBuildingsEnabled = true
//        mapView.settings.myLocationButton = true
//        
//        
//        let marker = GMSMarker()
//        marker.title = "UFG"
//        marker.position = camera.target
//        marker.snippet = "Universidade Federal de Goiás"
//        marker.appearAnimation = .pop
//        marker.map = mapView
//        
//        return mapView
//    }
    
    func getMarker(nome: String, descricao: String, localizacao: CLLocationCoordinate2D) -> GMSMarker {
        let marker = GMSMarker()
        marker.title = nome
        marker.position = localizacao
        marker.snippet = descricao
        marker.appearAnimation = .pop
        
        return marker
    }
    
    func drawPath(destination: CLLocation) {
        let origin = "\(mapView.myLocation?.coordinate.latitude), \(mapView.myLocation?.coordinate.longitude)"
        let endLocation = "\(destination.coordinate.latitude), \(destination.coordinate.longitude)"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let url = "https://maps.googleapis.com/maps/apis/directions/json?origin=\(origin)&destination=\(endLocation)&key=\(appDelegate.API_KEY)"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.blue
                polyline.map = self.mapView
            }
            
        }
    }
    
    func setMarkers(categoria: String) {
        switch categoria {
            case "Lanconetes": break
                // CRIAR MARCADORES DE LANCONETES
            let marcador = getMarker(nome: "Reuni", descricao: "Lanconete", localizacao: CLLocationCoordinate2D(latitude: -16.6035343, longitude: -49.2664894))
            
            
        default:
            break
        }
    }

}