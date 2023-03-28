//
//  MapSearchViewController.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 26/03/23.
//

import UIKit
import CoreData
import CoreLocation
import MapKit


class MapSearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var buscarBotton: UIButton!
    @IBOutlet weak var searchMapView: MKMapView!
    
    //Manejador de búsquedas
    var locationManager: CLLocationManager!
    
    var localidad: Localidad? = nil
    
    //Solo para generar un objeto Localidad de forma temporal
    let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        
        //La precisión determina la frecuencia con la cual
        //se toman las lecturas por tanto entre mayoy presisión mayor
        //gasto de bateria
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
        searchMapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Establece la coordenada actual
        
        if localidad != nil { // Si se está editando la localidad actual, entonces solo se presenta su ubicación
  
            let coordenadas = CLLocationCoordinate2D(latitude: localidad!.latitude, longitude: localidad!.longitude)
            searchMapView.setRegion(MKCoordinateRegion(center:   coordenadas, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
            addMarker(title: localidad!.name ?? NSLocalizedString("MAPA_PIN_TITLE_DEFAULT", comment: "MAPA_PIN_TITLE_DEFAULT"), coordenadas: coordenadas)

        }
   
        
    }
    
    
    func verifiarPermisosGPS() -> Bool {
        var result = false
        // Verificamos si la geolocalización está activada en el dispositivo
        if CLLocationManager.locationServicesEnabled() {
            // Verificar permisos para mi aplicación
            if locationManager.authorizationStatus == .authorizedAlways ||
                locationManager.authorizationStatus == .authorizedWhenInUse {
                // si tengo permiso de usar el gps, entonces iniciamos la detección
                //locationManager.startUpdatingLocation()
                result = true
            }
            else {
                // no tenemos permisos, hay que volver a solicitarlos, solo se ejecuta usa soloa vez
                locationManager.requestAlwaysAuthorization()
            }
        }
        else {
            let title = NSLocalizedString("ALERT_TITLE_ACTIVAR_GPS", comment: "ALERT_TITLE_ACTIVAR_GPS")
            let message = NSLocalizedString("ALERT_MENSSAGE_ACTIVAR_GPS", comment: "ALERT_MENSSAGE_ACTIVAR_GPS")
            let aceptText = NSLocalizedString("ALERT_ACEPT", comment: "ALERT_ACEPT")
            let cancelText = NSLocalizedString("ALERT_CANCEL", comment: "ALERT_CANCEL")
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let alertActionCancel = UIAlertAction(title: cancelText, style: .cancel)
            let alertAction = UIAlertAction(title: aceptText, style: .default) {_ in
                
                // Se abre los setting para la aplicación y pueda cambiar los permisos
                let settingsURL = URL(string: UIApplication.openSettingsURLString)!
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:])
                }
            }
            
            alert.addAction(alertActionCancel)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
            
            //---------------------------------
            //Inica el monitoreo de la localización actual
            //locationManager.startUpdatingLocation()
        }
        return result
    }
    
    
    
    
    func addMarker(title: String, coordenadas: CLLocationCoordinate2D){
        let pin = MKPointAnnotation()
        pin.coordinate = coordenadas
        pin.title = title
        searchMapView.addAnnotation(pin)
    }
    
    
    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: UIButton) {
        print(String(describing: sender.tag))
    }
    */
    
    @IBAction func buscarButton(_ sender: UIButton) {
        let strLugar = searchTextField.text ?? ""
        if !Helper.validateText(text: strLugar) {
            Helper.AlertMessageOk(title: NSLocalizedString("ALERT_TITLE_VACIO", comment: "ALERT_TITLE_VACIO"), message: NSLocalizedString("ALERT_MENSSAGE_VACIO", comment: "ALERT_MENSSAGE_VACIO"), viewController: self)
            return
        }
        getLocalidadDescription(strLugar: strLugar)
        
        
    }
    
    func getLocalidadDescription(strLugar: String){
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(strLugar) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    //Se ha encontrado almenos una ubicación
                    if (self.localidad == nil){
                        self.localidad = Localidad(context: self.childContext)
                       
                    }
                    self.localidad?.name = placemark.name
                    self.localidad?.descripcion = placemark.locality
                    self.localidad?.state = placemark.administrativeArea
                    self.localidad?.country = placemark.country
                    self.localidad?.selected = false
                    self.localidad?.latitude = location.coordinate.latitude
                    self.localidad?.longitude = location.coordinate.longitude
                    
                    
                    self.searchMapView.setRegion(MKCoordinateRegion(center:   location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
                    self.addMarker(title: placemark.name ?? "Localidad buscada", coordenadas: location.coordinate)
                    return
                }
            }
            else {
                let title = NSLocalizedString("ALERT_TITLE_LOCALIDAD_NOT_FOUND", comment: "ALERT_TITLE_LOCALIDAD_NOT_FOUND")
                let message = NSLocalizedString("ALERT_MENSSAGE_LOCALIDAD_NOT_FOUND", comment: "ALERT_MENSSAGE_LOCALIDAD_NOT_FOUND")
                Helper.AlertMessageOk(title: title, message: message, viewController: self)
            }
        }
        
    }
    
 
}
    



extension MapSearchViewController: CLLocationManagerDelegate{
}

extension MapSearchViewController: MKMapViewDelegate{
    
   
}
