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
        
        super.icon = icone
        super.appearAnimation = .pop
        
        setIconSize(height: 40, width: 40)
    }
    
    private func setIconSize(height: CGFloat, width: CGFloat) {
        super.iconView?.frame.size.height = height
        super.iconView?.frame.size.width = width
    }
    
}
