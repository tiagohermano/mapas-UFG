//
//  Marker.swift
//  Mapa-UFG
//
//  Created by Tiago Ferreira Hermano on 22/05/17.
//  Copyright © 2017 Tiago Hermano. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class Marker: GMSMarker {
    
    func getMarker(nome: String, descricao: String, localizacao: CLLocationCoordinate2D) -> GMSMarker {
        let marker = GMSMarker()
        marker.title = nome
        marker.position = localizacao
        marker.snippet = descricao
        marker.appearAnimation = .pop
        
        return marker
    }
}
