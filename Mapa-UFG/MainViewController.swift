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
    
    static var mainView:UIView?
    
    enum Categories {
        case Lanchonetes,
             Xerox,
             Restaurantes,
             Bibliotecas,
             Centros_aulas,
             Bancos
    }
    
    @IBOutlet weak var obterTrajetoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        
        MainViewController.mainView = view
        
        
        let map = Map()
        mapView?.delegate = self
        
        mapView = map.setInitialMap()
        
//        let reuni = CLLocationCoordinate2D(latitude: -16.6035343, longitude: -49.2664894)
//        let marker = Marker(nome: "Reuni", descricao: "Lanchonete", localizacao: reuni, icone: #imageLiteral(resourceName: "PLACEHOLDERS-1"))
//        marker.map = mapView
        
//        map.drawPath(destination: reuni)
        
        view = mapView
        
        if let categoriaSelecionada = selectedCategory {
            print("Categoria Selecionada: \(categoriaSelecionada)")
        }
    
        showMarkers(selectedCategory)
        
//        let mapView = Map.setInitialMap()
//        view = mapView
    }
    
    func configObterTrajetoButton() {
        obterTrajetoButton.layer.cornerRadius = obterTrajetoButton.frame.width / 2
        obterTrajetoButton.clipsToBounds = true
    }
    
    func showMarkers(_ selectedCategory:String?) {
        let markers = getMarkersFromJSON(JSONfile: "Locais", selectedCategory)
        
        for marker in markers {
            marker.map = mapView
        }
        
        view = mapView
    }
    
    func getMarkersFromJSON(JSONfile:String, _ selectedCategory:String?) -> [Marker] {
        if let jsonPath = Bundle.main.path(forResource: JSONfile, ofType: "json") {
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
                        case "Xerox" :
                            let xerox = jsonObj["xerox"]
                            marcadores = locais.getMarkers(locaisCategoria: xerox, categoria: "xerox")
                        case "Restaurantes" :
                            let restaurantes = jsonObj["restaurantes"]
                            marcadores = locais.getMarkers(locaisCategoria: restaurantes, categoria: "restaurantes")
                        case "Bibliotecas" :
                            let bibliotecas = jsonObj["bibliotecas"]
                            marcadores = locais.getMarkers(locaisCategoria: bibliotecas, categoria: "bibliotecas")
                        case "Centros de Aulas" :
                            let centro_aulas = jsonObj["centros de aulas"]
                            marcadores = locais.getMarkers(locaisCategoria: centro_aulas, categoria: "centros_aulas")
                        case "Bancos" :
                            let bancos = jsonObj["bancos"]
                            marcadores = locais.getMarkers(locaisCategoria: bancos, categoria: "bancos")
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
        return marcadores
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

