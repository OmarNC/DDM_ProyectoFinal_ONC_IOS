//
//  WeatherNowDataManager.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 26/03/23.
//

import Foundation


class WeatherNowDataManager {
    private var weatherNow : WeatherNow? = nil
    private var localidad: Localidad? = nil
    private var responseFunctions: ResponseToGetJSONDelegate
   //private var viewController: UIViewController? = nil
    
    init(localidad: Localidad, responseFunction: ResponseToGetJSONDelegate){
        self.localidad = localidad
        self.responseFunctions = responseFunction
    }
    func fetch(){
        
        if localidad == nil { return }
        
        let strUrl = ConnectionURL.getURLWeather(lat: localidad!.latitude, lon: localidad!.longitude)
        print("URL: \(strUrl)")
        
        if MonitorRed.instance.conexionActiva == false {
            //Si la conexión no está activa
            
            DispatchQueue.main.async {
                self.responseFunctions.networkUnavailableAction()
            }
            
            print("AVISO: No se tiene una conexión a Internet activa")
            return
        }
        if MonitorRed.instance.conexionActiva == true {
            if let url = URL(string: strUrl) {
                
                // 1. Establecer la configuración por defecto para la sessión
                let sessionConfig = URLSessionConfiguration.default
                
                // 2. Crear la sesión
                let session = URLSession(configuration: sessionConfig)
                
                // 3. Se crea la solicitud (request) del recurso
                let request = URLRequest(url: url)
                
                // 4. Se crea la terea para responder a la petición
                let task = session.dataTask(with: request) { bytes, response, error in
                    
                    if error != nil {  //Si hay un error el la petición del recurso JSON
                        
                        //Se deja al delegado actuar a consecuencia del error
                        DispatchQueue.main.async {
                            self.responseFunctions.requestFailedAction(error: error!)
                        }
                        
                        print("ERROR: al descargar el pronóstico: \(String(describing:error))")
                        return
                    }
                    //Consultar el JSON
                    do {
                        guard let data = bytes else { return }
                        //Se guarda la información recabada
                        self.weatherNow = try JSONDecoder().decode(WeatherNow.self, from: data)
                        
                        DispatchQueue.main.async {
                            //Se deja al delegado actuar cuando ha tenido exito en la obtención del recurso
                            self.responseFunctions.responseComplationHandler()
                         
                        }
                    }
                    catch {
                        DispatchQueue.main.async {
                            self.responseFunctions.decodeJSONErrorAction(error: error)
                        }
                        print("ERROR: Deserializar el JSON: \(String(describing:error))")
                    }
                }
                
                // 5. Se inicia la tarea
                task.resume()
            }
        }
                
    }
    
    
    //Establece la localidad y actualiza los datos pronóstico
    func setLocalidad(localidad: Localidad){
        self.localidad = localidad
        fetch()
    }
    
    //Establece la localidad y actualiza los datos pronóstico
    func getLocalidad() -> Localidad?{
        return localidad
    }
    
    func getWeather() -> WeatherNow? {
        
        if (weatherNow == nil || localidad == nil) { return nil}
        return weatherNow
    }
}
