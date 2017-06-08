//
//  Menu.swift
//  Mapa-UFG
//
//  Created by Dev13 on 08/06/17.
//  Copyright © 2017 Tiago Hermano. All rights reserved.
//

import Foundation
import UIKit

class Menu: UITableViewController {
    var itensMenu: [String] = ["Lançonetes", "Xerox", "Restaurantes", "Bibliotecas", "Centros de Aulas"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itensMenu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celulaReuso = "celula"
        let celula = tableView.dequeueReusableCell(withIdentifier: celulaReuso, for: indexPath)
        celula.textLabel?.text = itensMenu[indexPath.row]
        
        return celula
    }
    
}
