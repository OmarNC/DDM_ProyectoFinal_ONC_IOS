//
//  WeatherPollutionViewController.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 26/03/23.
//

import UIKit
import CoreData

enum GasName{ case SO2, NO2, PM10, PM2_5, O3, CO, NH3, NO }

class WeatherPollutionViewController: UIViewController {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var calidadAireLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var coLabel: UILabel!
    @IBOutlet weak var no2Label: UILabel!
    @IBOutlet weak var o3Label: UILabel!
    @IBOutlet weak var so2Label: UILabel!
    @IBOutlet weak var pm2_5Label: UILabel!
    @IBOutlet weak var pm10Label: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var coImageView: UIImageView!
    @IBOutlet weak var no2ImageView: UIImageView!
    @IBOutlet weak var o3ImageView: UIImageView!
    @IBOutlet weak var so2ImageView: UIImageView!
    @IBOutlet weak var pm2_5ImageView: UIImageView!
    @IBOutlet weak var pm10ImageView: UIImageView!
    
    //Obtener el contexto para CoreData
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var localidadesDataManager: LocalidadesDataManager?
    private var localidad: Localidad? = nil
  
    //Se crea el manejador de la base de datos
    var dataManager : WeatherPollutionDataManager?
    //(Solo para generar un objeto localidad)
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
          
          dataManager = WeatherPollutionDataManager(localidad: localidad!, responseFunction: self)
          dataManager?.fetch()
    }
    
    
    func fillControlsView(){
        
        let weather: WeatherPollution? = dataManager?.getWeatherPollution()
  
        dateLabel.text = Helper.dateTimeToString(unixTimestamp: Double(weather?.list.first?.dt ?? 0), format: "HH:mm dd/MM/yyyy")
        countryLabel.text = localidad?.name ?? "Ciudad"
        calidadAireLabel.text = String(format: "Índice de calidad de aire: %d", weather?.list.first?.main.aqi ?? 0)
        mainLabel.text = getQualitativeName(index: weather?.list.first?.main.aqi ?? 0)
        coLabel.text = String(format: "%.1f ug/m3", weather?.list.first?.components["co"] ?? 0.0)
        no2Label.text = String(format: "%.1f ug/m3", weather?.list.first?.components["no2"] ?? 0.0)
        o3Label.text =   String(format: "%.1f ug/m3", weather?.list.first?.components["o3"] ?? 0.0)
        so2Label.text =  String(format: "%.1f ug/m3", weather?.list.first?.components["so2"] ?? 0.0)
        pm2_5Label.text =  String(format: "%.1f ug/m3", weather?.list.first?.components["pm2_5"] ?? 0.0)
        pm10Label.text =  String(format: "%.1f ug/m3", weather?.list.first?.components["pm10"] ?? 0.0)
        
        /*
        iconImageView.image = UIImage(named: "ic_face_\(weather?.list.first?.main.aqi ?? 0).svg")
       
        var aqi = getQualitativeIndexByConcentration(valor: weather?.list.first?.components["co"] ?? 0.0, nombreGas: GasName.CO)
        coImageView.image = UIImage(named: "ic_face_\(aqi).svg")
        
        aqi = getQualitativeIndexByConcentration(valor: weather?.list.first?.components["no2"] ?? 0.0, nombreGas: GasName.NO2)
        no2ImageView.image = UIImage(named: "ic_face_\(aqi).svg")
        aqi = getQualitativeIndexByConcentration(valor: weather?.list.first?.components["o3"] ?? 0.0, nombreGas: GasName.O3)
        o3ImageView.image = UIImage(named: "ic_face_\(aqi).svg")
        aqi = getQualitativeIndexByConcentration(valor: weather?.list.first?.components["so2"] ?? 0.0, nombreGas: GasName.SO2)
        so2ImageView.image = UIImage(named: "ic_face_\(aqi).svg")
        aqi = getQualitativeIndexByConcentration(valor: weather?.list.first?.components["pm2_5"] ?? 0.0, nombreGas: GasName.PM2_5)
        pm2_5ImageView.image = UIImage(named: "ic_face_\(aqi).svg")
        aqi = getQualitativeIndexByConcentration(valor: weather?.list.first?.components["pm10"] ?? 0.0, nombreGas: GasName.PM2_5)
        pm10ImageView.image = UIImage(named: "ic_face_\(aqi).svg")
         */
       
  
        
    }
    
    func indefOfRange(valor: Double, array: [Double]) -> Int {
            var index = 0
            for (i, dato) in array.enumerated() {
                if (valor < dato){
                    index = i
                    break
                }
            }
            return  index
        }

    func getQualitativeIndexByConcentration(valor: Double, nombreGas: GasName) -> Int{
        var index = 0
        let tablaSO2 = [0.0, 20.0, 80.0, 250.0, 350.0]
        let tablaNO2 = [0.0, 40.0, 70.0, 150.0, 200.0]
        let tablaPM10 = [0.0, 20.0, 50.0, 100.0, 200.0]
        let tablaPM2_5 = [0.0, 10.0, 25.0, 50.0, 75.0]
        let tablaO3 = [0.0, 60.0, 100.0, 140.0, 180.0]
        let tablaC0 = [0.0, 4400.0, 9400.0, 12400.0, 15400.0]
        switch nombreGas{
        case GasName.SO2: index = indefOfRange(valor: valor, array: tablaSO2)
        case GasName.NO2: index = indefOfRange(valor: valor, array: tablaNO2)
        case GasName.PM10: index = indefOfRange(valor: valor, array: tablaPM10)
        case GasName.PM2_5: index = indefOfRange(valor: valor, array: tablaPM2_5)
        case GasName.O3: index = indefOfRange(valor: valor, array: tablaO3)
        case GasName.CO: index = indefOfRange(valor: valor, array: tablaC0)
        default:  index = 0
        }
        return index
    }
    


    func getQualitativeName(index: Int?) -> String{
        let tabla = ["Sin determinar","Bueno", "Razonable", "Moderado", "Pobre", "Muy mala"]
        guard let indice = index else { return tabla[0] }
        return tabla[indice]
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ListLocalidadesTableViewController {
            let listLocationVC = segue.destination as! ListLocalidadesTableViewController
            listLocationVC.responseFunctions = self
        }
    }
    
  
}


//MARK: - Protocolo para el manejo de la actualización de la localidad seleccionada

extension WeatherPollutionViewController: UpdateDataDelegate{
    
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
            dataManager = WeatherPollutionDataManager(localidad: localidad!, responseFunction: self)
            dataManager?.fetch()
            fillControlsView()
            
        }

    }
}




 
//MARK: - Procolos empleado para el manejo de errores en la solicitud del JSON
extension WeatherPollutionViewController: ResponseToGetJSONDelegate{
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
        fillControlsView()
    }
    
}

