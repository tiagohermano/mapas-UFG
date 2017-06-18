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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        
        let campusSamambaia = CLLocation.init(latitude: -16.6021102, longitude: -49.2656253)
        
        let map = Map()
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
        
        let mapCamera = Map.defaultMapCamera
        mapView = GMSMapView.map(withFrame: .zero, camera: mapCamera)
        mapView?.delegate = self
        
        if let jsonPath = Bundle.main.path(forResource: "Locais", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .alwaysMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    let locais = Marker()
                    
                    if let categoriaSelecionada = selectedCategory {
                        switch categoriaSelecionada {
                        case "Lanchonetes" :
                            let lanchonetes = jsonObj["lanchonetes"]
                            marcadores = locais.getMarkers(locaisCategoria: lanchonetes, categoria: "lanchonetes")
                            break
                        case "Xerox" :
                            let xerox = jsonObj["xerox"]
                            marcadores = locais.getMarkers(locaisCategoria: xerox, categoria: "xerox")
                            break
                        case "Restaurantes" :
                            let restaurantes = jsonObj["restaurantes"]
                            marcadores = locais.getMarkers(locaisCategoria: restaurantes, categoria: "restaurantes")
                            break
                        case "Bibliotecas" :
                            let bibliotecas = jsonObj["bibliotecas"]
                            marcadores = locais.getMarkers(locaisCategoria: bibliotecas, categoria: "bibliotecas")
                            break
                        case "Centros de Aulas" :
                            let centro_aulas = jsonObj["centros de aulas"]
                            marcadores = locais.getMarkers(locaisCategoria: centro_aulas, categoria: "centros_aulas")
                            break
                        case "Bancos" :
                            let bancos = jsonObj["bancos"]
                            marcadores = locais.getMarkers(locaisCategoria: bancos, categoria: "bancos")
                            break
                        default:
                            break
                        }
                        
                        for marcador in marcadores {
                            marcador.map = mapView
                        }
                        view = mapView
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
        
//        let mapView = Map.setInitialMap()
//        view = mapView
        // Do any additional setup after loading the view, typically from a nib.
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

