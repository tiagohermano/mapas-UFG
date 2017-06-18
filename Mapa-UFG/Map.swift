//
//  Map.swift
//  Mapa-UFG
//
//  Created by Tiago Ferreira Hermano on 21/05/17.
//  Copyright © 2017 Tiago Hermano. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire
import MapKit

class Map: GMSMapView {
    var mapView: GMSMapView!
    var mapCamera: GMSCameraPosition!
    var locationManager: CLLocationManager!
    var userLocation: CLLocation?
    var selectedCategory: String!
    
    static var defaultMapCamera = GMSCameraPosition.camera(withLatitude: -16.605961, longitude:  -49.262723, zoom: 14.6)
    
    func setInitialMap(location: CLLocation) -> GMSMapView {
        mapCamera = Map.defaultMapCamera
        mapView = GMSMapView.map(withFrame: .zero, camera: mapCamera!)
        
        configMapViewSettings()
        configLocationManager()
        
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
        
        if status == .authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
        }
    }
    
    private func configLocationManager() {
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }
    
    private func configMapViewSettings() {
        mapView?.settings.compassButton = true
        mapView?.isMyLocationEnabled = true
        mapView?.isBuildingsEnabled = true
        mapView?.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations.last!
        
        if let localizacaoUsuario = userLocation {
            print("Localizacao usuario: \(localizacaoUsuario)")
        }
        
        // Exibe local
        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation!.coordinate.latitude, userLocation!.coordinate.longitude)
        
        // Monta Exibição do mapa
        self.mapCamera = GMSCameraPosition.camera(withLatitude: localizacao.latitude, longitude: localizacao.longitude, zoom: 18)
    }
    
    
    // MARK: - GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.mapView.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.mapView.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.mapView.isMyLocationEnabled = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        self.mapView.isMyLocationEnabled = true
        self.mapView.selectedMarker = nil
        return false
    }
    
    
    func clearMarkers() {
        mapView?.clear()
    }
    
    func drawPath(destination: CLLocationCoordinate2D) {
//        let origin = "-16.6021102,-49.2656253"
        
        let origin = "\(userLocation?.coordinate.latitude),\(userLocation?.coordinate.longitude)"
        
        let endLocation = "\(destination.latitude),\(destination.longitude)"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(endLocation)&key=\(appDelegate.API_KEY)&mode=walking"
        
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
    
}

extension Map: MKMapViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    
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
