//
//  Map.swift
//  Mapa-UFG
//
//  Created by Tiago Ferreira Hermano on 21/05/17.
//  Copyright © 2017 Tiago Hermano. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire
import MapKit

class Map: GMSMapView {
    var mapView: GMSMapView?
    var mapCamera: GMSCameraPosition?
    var locationManager: CLLocationManager?
    
    func setInitialMap(location: CLLocation) -> GMSMapView {
//        mapCamera = GMSCameraPosition.camera(withLatitude: -16.6021102, longitude: -49.2656253, zoom: 16)
        mapCamera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)
        mapView = GMSMapView.map(withFrame: .zero, camera: mapCamera!)
        
        mapView?.settings.compassButton = true
        mapView?.isMyLocationEnabled = true
        mapView?.isBuildingsEnabled = true
        mapView?.settings.myLocationButton = true
        
        let marker = GMSMarker()
        marker.icon = #imageLiteral(resourceName: "placeholder")
        marker.title = "UFG"
        marker.position = (mapCamera?.target)!
        marker.snippet = "Universidade Federal de Goiás"
        marker.appearAnimation = .pop
        marker.map = mapView
        
        return mapView!
    }
    
    func showLocation(location: CLLocation) {
        self.mapCamera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 18)
        mapView = GMSMapView.map(withFrame: .zero, camera: mapCamera!)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined {
            let alertController = UIAlertController(title: "Permissão de localização", message: "Necessária a permissão para o acesso à sua localização.", preferredStyle: .alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir Configurações", style: .default, handler: { (alertaConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(acaoConfiguracoes)
            alertController.addAction(acaoCancelar)
            
            alertController.show()
        }
    }
    
    func configLocationManager() {
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let local = locations.last!
        
        // Exibe local
        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(local.coordinate.latitude, local.coordinate.longitude)
        
        // Monta Exibição do mapa
        self.mapCamera = GMSCameraPosition.camera(withLatitude: localizacao.latitude, longitude: localizacao.longitude, zoom: 18)
    }
    
    func getMarker(nome: String, descricao: String, localizacao: CLLocationCoordinate2D) -> GMSMarker {
        let marker = GMSMarker()
        marker.title = nome
        marker.position = localizacao
        marker.snippet = descricao
        marker.appearAnimation = .pop
        
        return marker
    }
    
    func drawPath(destination: CLLocation) {
        let origin = "\(mapView?.myLocation?.coordinate.latitude), \(mapView?.myLocation?.coordinate.longitude)"
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

extension Map: MKMapViewDelegate, CLLocationManagerDelegate {
    
}

extension UIAlertController {
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else
            if let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(controller: selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion);
        }
    }
}
