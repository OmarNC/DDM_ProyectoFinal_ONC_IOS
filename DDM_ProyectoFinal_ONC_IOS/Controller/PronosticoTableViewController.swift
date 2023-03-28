//
//  PronosticoTableViewController.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 25/03/23.
//

import UIKit
import CoreData

class PronosticoTableViewController: UITableViewController {

    
    //Obtener el contexto para CoreData
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var localidadesDataManager: LocalidadesDataManager?
    private var localidad: Localidad? = nil
    
    //Se crea el manejador de la base de datos
    var dataManager : WeatherForecastDataManager?
    //(Solo para generar un objeto localidad temporal)
    let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localidadesDataManager = LocalidadesDataManager(context: contexto)
        if localidadesDataManager?.getIndexLocalidadSelected() ?? -1 < 0 { //Si no hay localidades se emplea una temporal
            localidad = Localidad(context: childContext)
            localidad?.name = "C.U."
            localidad?.descripcion = "Universidad Nacional Autónoma de México"
            localidad?.state = "CDMX"
            localidad?.country = "México"
            localidad?.latitude = 19.324319472655855
            localidad?.longitude = -99.18636020430644
            localidad?.selected = false
        }
        else { //Se ha seleccionado una localidad previa
            let indice = localidadesDataManager?.getIndexLocalidadSelected() ?? 0
            localidad = localidadesDataManager?.getLocalidad(at: indice)
        }
        
        dataManager = WeatherForecastDataManager(localidad: localidad!, responseFunction: self)
        dataManager?.fetch()
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Leer las datos de la API
        return dataManager?.countPronosticos() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return localidad?.name ?? ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PronosticoTableViewItem", for: indexPath) as! PronosticoTableViewCell
        
        let pronostico: WeatherForecastItem? = dataManager?.getPronostico(at: indexPath.row)
        
        /*
         cell.dateLabel.text = "12:30 a.m. 22/02/2023"
         cell.nameLabel.text = "main"
         cell.descriptionLabel.text = "desc"
         cell.tempLabel.text = "30.1°C"
         cell.tempMinMaxLabel.text = "20.1° | 30.2° C"
         cell.humidityLabel.text = "20%"
         cell.rainLabel.text = "3.0 %"
         cell.pressionLabel.text = "1019hPa"
         cell.climaImageView.image = UIImage(systemName: "ic_02d.png")
         */
        
        cell.dateLabel.text = Helper.dateTimeToString(unixTimestamp: Double(pronostico?.dt ?? 0), format: "HH:mm dd/MM/yyyy")
        cell.nameLabel.text = pronostico?.weather.first?.main
        cell.descriptionLabel.text =  pronostico?.weather.first?.main.description
        cell.tempLabel.text =  String(format: "%.1f°C", pronostico?.main.temp ?? 0.0)
        cell.tempMinMaxLabel.text =   String(format: "%.1f°C | %.1f°C", pronostico?.main.tempMin ?? 0.0, pronostico?.main.tempMax ?? 0.0)
        cell.humidityLabel.text =  String(format: "%d %%", pronostico?.main.humidity ?? 0)
        cell.rainLabel.text =  String(format: "%.1f mm", pronostico?.rain?.the3H ?? 0.0)
        cell.pressionLabel.text =  String(format: "%d hPa", pronostico?.main.pressure ?? 0.0)
        cell.climaImageView.image = UIImage(named: "ic_\(pronostico?.weather.first?.icon ?? "01d").png")
        
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ListLocalidadesTableViewController {
            let listLocationVC = segue.destination as! ListLocalidadesTableViewController
            listLocationVC.responseFunctions = self
        }
    }
    
  
}


//MARK: - Protocolo para el manejo de la actualización de la localidad seleccionada

extension PronosticoTableViewController: UpdateDataDelegate{
    
    func updataData(at: Int) {
        localidadesDataManager?.fetch()
        var updateData = false
        let newLocalidadIndex = localidadesDataManager?.getIndexLocalidadSelected() ?? -1
        if newLocalidadIndex >= 0 {
            let newLocalidad = localidadesDataManager?.getLocalidad(at: newLocalidadIndex)
            if localidad == nil {
                localidad = newLocalidad
                updateData = true
            }
            else if newLocalidad?.name != localidad!.name {
                localidad = newLocalidad
                updateData = true
            }
        }
        else { //Si no hay localidades se emplea una temporal
            localidad = Localidad(context: childContext)
            localidad?.name = "C.U."
            localidad?.descripcion = "Universidad Nacional Autónoma de México"
            localidad?.state = "CDMX"
            localidad?.country = "México"
            localidad?.latitude = 19.324319472655855
            localidad?.longitude = -99.18636020430644
            localidad?.selected = false
            updateData = true
        }
        
        if updateData {
            dataManager = WeatherForecastDataManager(localidad: localidad!, responseFunction: self)
            dataManager?.fetch()
            tableView.reloadData()
            
        }

    }
}


//MARK: - Procolos empleado para el manejo de errores en la solicitud del JSON
extension PronosticoTableViewController: ResponseToGetJSONDelegate{
    func requestFailedAction(error: Any) {
    
        Helper.AlertMessageOk(title: NSLocalizedString("DOWNLOAD_BTN_ALERT_TITLE2", comment: "DOWNLOAD_BTN_ALERT_TITLE2"), message: NSLocalizedString("DOWNLOAD_BTN_ALERT_MESSAGE2", comment: "DOWNLOAD_BTN_ALERT_MESSAGE2"), viewController: self)
    }
    
    func networkUnavailableAction() {
      
        Helper.AlertMessageOk(title: NSLocalizedString("DOWNLOAD_BTN_ALERT_TITLE", comment: "DOWNLOAD_BTN_ALERT_TITLE"), message: NSLocalizedString("DOWNLOAD_BTN_ALERT_MESSAGE", comment: "DOWNLOAD_BTN_ALERT_MESSAGE"), viewController: self)
    }
    
    func decodeJSONErrorAction(error: Any) {
        Helper.AlertMessageOk(title: NSLocalizedString("DOWNLOAD_BTN_ALERT_TITLE2", comment: "DOWNLOAD_BTN_ALERT_TITLE2"), message: NSLocalizedString("DOWNLOAD_BTN_ALERT_MESSAGE2", comment: "DOWNLOAD_BTN_ALERT_MESSAGE2"), viewController: self)
    }
    
    func responseComplationHandler() {
        self.tableView.reloadData()
    }
    
    
}
