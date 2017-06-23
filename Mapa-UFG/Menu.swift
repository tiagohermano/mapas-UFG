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
    var itensMenu: [String] = ["Institutos/Faculdades", "Lanchonetes", "Xerox", "Restaurantes", "Bibliotecas", "Centros de Aulas", "Bancos"]
    var itensImage: [UIImage] = [#imageLiteral(resourceName: "menu_institutos"), #imageLiteral(resourceName: "menu_lanchonete"), #imageLiteral(resourceName: "menu_xerox"), #imageLiteral(resourceName: "menu_restaurante"), #imageLiteral(resourceName: "menu_biblioteca"), #imageLiteral(resourceName: "menu_centro_aulas"), #imageLiteral(resourceName: "menu_banco")]
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itensMenu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celulaReuso = "celula"
        let celula = tableView.dequeueReusableCell(withIdentifier: celulaReuso, for: indexPath) as! MenuTableCell
        
        celula.titleLabel.text = itensMenu[indexPath.row]
        celula.iconImageView.image = itensImage[indexPath.row]

        return celula
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mapa" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let categoriaSelecionada = self.itensMenu[indexPath.row]
                let nav = segue.destination as! UINavigationController
                let viewControllerDestino = nav.topViewController as! MainViewController
                viewControllerDestino.selectedCategory = categoriaSelecionada
            }
        }
    }
}
