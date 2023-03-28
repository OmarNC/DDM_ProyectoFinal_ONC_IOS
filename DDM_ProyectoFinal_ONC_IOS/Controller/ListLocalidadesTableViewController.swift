//
//  ListLocalidadesTableViewController.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 27/03/23.
//

import UIKit

class ListLocalidadesTableViewController: UITableViewController {

    //Obtener el contexto para CoreData
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Se crea el manejador de la base de datos
    var dataManager : LocalidadesDataManager?
    
    var responseFunctions: UpdateDataDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = LocalidadesDataManager(context: contexto)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataManager?.countLocalidades() ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListLocalidadesTableViewCell", for: indexPath) as! ListLocalidadesTableViewCell
        
        cell.countryLabel.text = dataManager?.getLocalidad(at: indexPath.row)?.name
        cell.descriptionLabel.text = dataManager?.getLocalidad(at: indexPath.row)?.descripcion
        cell.arrowImageView.isHidden = !(dataManager?.getLocalidad(at: indexPath.row)?.selected ?? false)


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
        if (dataManager?.getLocalidad(at: indexPath.row).selected == false){
            let title = NSLocalizedString("ALERT_TITLE_CHANGE", comment: "ALERT_TITLE_CHANGE")
            let message = NSLocalizedString("ALERT_MENSSAGE_CHANGE", comment: "ALERT_MENSSAGE_CHANGE")
            let aceptText = NSLocalizedString("ALERT_ACEPT", comment: "ALERT_ACEPT")
            let cancelText = NSLocalizedString("ALERT_CANCEL", comment: "ALERT_CANCEL")
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let alertActionCancel = UIAlertAction(title: cancelText, style: .cancel)
            let alertAction = UIAlertAction(title: aceptText, style: .default) {_ in
                self.dataManager?.checkedLocalidad(at: indexPath.row)
                self.tableView.reloadData()
            }
            
            alert.addAction(alertActionCancel)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        }
         */
        
        self.dataManager?.checkedLocalidad(at: indexPath.row)
        self.tableView.reloadData()
        
        responseFunctions?.updataData(at: indexPath.row)
        
       
       
    }
    

}
