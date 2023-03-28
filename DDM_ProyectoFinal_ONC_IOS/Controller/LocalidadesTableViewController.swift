//
//  LocalidadesTableViewController.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 15/03/23.
//

import UIKit

class LocalidadesTableViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var emptyLabel: UILabel!
    
    //Obtener el contexto para CoreData
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Se crea el manejador de la base de datos
    var dataManager : LocalidadesDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dataManager = LocalidadesDataManager(context: contexto)
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        emptyLabel.isHidden = (dataManager?.countLocalidades() ?? 0) > 0

        return dataManager?.countLocalidades() ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "LocalidadItemTableViewItem", for: indexPath) as! LocalidadTableViewCell
        let localidad = dataManager?.getLocalidad(at: indexPath.row)
        
        cell.nameLabel.text = localidad?.name
        cell.descriptionLable.text = localidad?.descripcion
        cell.stateLabel.text = localidad?.state
        cell.countryLabel.text = localidad?.country
        cell.latitudeLabel.text =  String(localidad?.latitude ?? 0.0)
        cell.longitudeLabel.text = String(localidad?.longitude ?? 0.0)
  
        return cell
    }
    
    
    //Modo edición del TableView
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView.isEditing {
            return nil
        }
        
        //SE agrega el botón de borrar
        let action = UIContextualAction(style: .destructive, title: NSLocalizedString("ALERT_TITLE_BORRAR", comment: "ALERT_TITLE_BORRAR")) {(action, view, completionHandler) in
            
            self.dataManager?.deleteLocalidad(at: indexPath.row)
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            self.dataManager?.deleteLocalidad(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    // MARK: - Navigation
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "DetalleLocalidadSegue", sender: self)
    }
     */
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "AddLocalidadSegue" {
            if let indexSelected = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexSelected, animated: true)
            }
        }
        else if segue.identifier == "DetalleLocalidadSegue" {
            let destino = segue.destination as! LocalidadDetalleViewController
            let indexSelected = tableView.indexPathForSelectedRow?.row
            destino.localidad = dataManager?.getLocalidad(at: indexSelected!)
        }
       
    }
    
    //Segue ejecutado cuando el DetalleViewController aprieta el botón save
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue)
    {
        let source = segue.source as! LocalidadDetalleViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow
        {
            //Cuando se ha seleccionado un elemento y se ha mostrado el detalle
            // el renglón del tableView aun sigue seleccionado
            dataManager?.setLocalidad(localidad: source.localidad!, at: selectedIndexPath.row)
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }
        else {
            //Agregar nueva localidad.
            //Previamente, en la preparación del segue,  se ha deseleccionado
            //cualquier renglón para evitar confundirlo con el detalle
            dataManager?.saveData()
            dataManager?.fetchData()
            tableView.reloadData()
        }
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            addButton.isEnabled = true
            sender.title = NSLocalizedString("BUTTON_EDIT", comment: "BUTTON_EDIT")
        } else {
            tableView.setEditing(true, animated: true)
            addButton.isEnabled = false
            sender.title = NSLocalizedString("BUTTON_DONE", comment: "BUTTON_DONE")
        }
    }
    

}
