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

class MainViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var selectedCategory = "Nenhuma"
    
    enum CategoriaSelecionada {
        case Lanchonetes, Xerox, Restaurantes, Bibliotecas, CentrosAulas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        sideMenu()
        
        let map = Map()
        
        let campusSamambaia = CLLocation.init(latitude: -16.6021102, longitude: -49.2656253)
        let mapView = map.setInitialMap(location: campusSamambaia)
        
//        let reuni = CLLocationCoordinate2D(latitude: -16.6035343, longitude: -49.2664894)
//        let marker = Marker(nome: "Reuni", descricao: "Lanchonete", localizacao: reuni, icone: #imageLiteral(resourceName: "PLACEHOLDERS-1"))
//        marker.map = mapView
        
//        map.drawPath(destination: reuni)
        
        view = mapView
        
        print("Categoria Selecionada: \(self.selectedCategory)")
        
        if let jsonPath = Bundle.main.path(forResource: "Locais", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .alwaysMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    print("jsonData:\(jsonObj)")
                    
                    let lanchonetes = jsonObj["lanchonetes"]
                    let xerox = jsonObj["xerox"]
                    let restaurantes = jsonObj["restaurantes"]
                    let bibliotecas = jsonObj["bibliotecas"]
                    let centro_aulas = jsonObj["centros de aulas"]
                    
                    
                    
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid Filename/path")
        }
        
        switch selectedCategory {
        case "Lanchonetes":
            // Mostrar Lanchonetes
            break
        case "Xerox":
            //Mostar Xerox
            break
        case "Restaurantes":
            //Mostrar Restaurantes
            break
        case "Bibliotecas":
            //Mostrar Bibliotecas
            break
        case "Centros de Aulas":
            //Mostrar Centros de Aulas
            break
        default: break
            //Mostrar nada
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

