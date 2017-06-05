//
//  ViewController.swift
//  Mapa-UFG
//
//  Created by Tiago Ferreira Hermano on 20/05/17.
//  Copyright © 2017 Tiago Hermano. All rights reserved.
//

import UIKit
import GoogleMaps

class MainViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu()
        
        let map = Map()
        map.configLocationManager()
        
        let campusSamambaia = CLLocation.init(latitude: -16.6021102, longitude: -49.2656253)
        let mapView = map.setInitialMap(location: campusSamambaia)
        
        view = mapView
        
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

