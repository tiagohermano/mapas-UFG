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
    
    init(nome: String, descricao: String, localizacao: CLLocationCoordinate2D, icone: UIImage) {
        super.init()
        
        super.title = nome
        super.snippet = descricao
        super.position = localizacao
        
        super.icon = #imageLiteral(resourceName: "placeholder")
        super.appearAnimation = .pop
    }
    
}
