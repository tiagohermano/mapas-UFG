//
//  ViewController.swift
//  Mapa-UFG
//
//  Created by Tiago Ferreira Hermano on 20/05/17.
//  Copyright © 2017 Tiago Hermano. All rights reserved.
//
import Foundation
import UIKit
import GoogleMaps
import SwiftyJSON

class MainViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var selectedCategory:String?
    
    var mapView: GMSMapView?
    
    var marcadores:[Marker] = []
    
    public enum CategoriaSelecionada {
        case Lanchonetes, Xerox, Restaurantes, Bibliotecas, CentrosAulas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        sideMenu()
        
        let map = Map()
        
        let campusSamambaia = CLLocation.init(latitude: -16.6021102, longitude: -49.2656253)
        mapView = map.setInitialMap(location: campusSamambaia)
        
//        let reuni = CLLocationCoordinate2D(latitude: -16.6035343, longitude: -49.2664894)
//        let marker = Marker(nome: "Reuni", descricao: "Lanchonete", localizacao: reuni, icone: #imageLiteral(resourceName: "PLACEHOLDERS-1"))
//        marker.map = mapView
        
//        map.drawPath(destination: reuni)
        
        view = mapView
        map.isMyLocationEnabled = true
        print("LOCALIZACAO: \(map.myLocation)")
        
        if let categoriaSelecionada = selectedCategory {
            print("Categoria Selecionada: \(categoriaSelecionada)")
        }
        
        
        
//        let mapView = Map.setInitialMap()
//        view = mapView
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let jsonPath = Bundle.main.path(forResource: "Locais", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .alwaysMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    //                    print("jsonData:\(jsonObj)")
                    
                    let marker = Marker()
                    
                    if let categoriaSelecionada = selectedCategory {
                        switch categoriaSelecionada {
                        case "Lanchonetes" :
                            let lanchonetes = jsonObj["lanchonetes"]
                            marcadores = marker.getMarkers(locaisCategoria: lanchonetes, categoria: "lanchonetes")
                            //                            print(lanchonetes["Lanchonete Reuni"])
                            break
                        case "Xerox" :
                            let xerox = jsonObj["xerox"]
                            marcadores = marker.getMarkers(locaisCategoria: xerox, categoria: "xerox")
                            break
                        case "Restaurantes" :
                            let restaurantes = jsonObj["restaurantes"]
                            marcadores = marker.getMarkers(locaisCategoria: restaurantes, categoria: "restaurantes")
                            break
                        case "Bibliotecas" :
                            let bibliotecas = jsonObj["bibliotecas"]
                            marcadores = marker.getMarkers(locaisCategoria: bibliotecas, categoria: "bibliotecas")
                            break
                        case "Centros de Aulas" :
                            let centro_aulas = jsonObj["centros de aulas"]
                            marcadores = marker.getMarkers(locaisCategoria: centro_aulas, categoria: "centro_aulas")
                            print("CENTROS DE AULAS \(jsonObj["centros de aulas"])")
                            break
                        default:
                            break
                        }
                    }
                    
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid Filename/path")
        }
        
        let mapCamera = GMSCameraPosition.camera(withLatitude: -16.605961, longitude:  -49.262723, zoom: 14.8)
        mapView = GMSMapView.map(withFrame: .zero, camera: mapCamera)
        mapView?.delegate = self
        
        for marcador in marcadores {
            print("MARCADOR: \(marcador)")
            marcador.map = mapView
        }
        view = mapView
    }
    
    func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

