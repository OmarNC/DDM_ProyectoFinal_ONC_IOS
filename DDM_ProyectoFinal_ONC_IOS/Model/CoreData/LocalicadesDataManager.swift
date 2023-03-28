//
//  LocalicadDataManager.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 5/03/23.
//

import Foundation
import CoreData

class LocalidadesDataManager {
    private var localidades : [Localidad] = []
    private var context : NSManagedObjectContext
    private static var localidadSelected = -1
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetch()
    }
    
    
    func fetch(){
        do{
            self.localidades = try self.context.fetch(Localidad.fetchRequest())
            //inicializa la localidad seleccionada
            for (index, loc) in localidades.enumerated() {
                if loc.selected == true {
                    LocalidadesDataManager.localidadSelected = index
                }
            }
        }
        catch{
            print("ERROR: No se ha podido leer la base de datos")
        }
    }
    
    func getIndexLocalidadSelected() -> Int {
        return LocalidadesDataManager.localidadSelected
    }
    
    func getLocalidad(at index: Int) -> Localidad? {
        if index < 0 || index >= localidades.count {return nil}
        return localidades[index]
    }
    
    func checkedLocalidad(at index: Int)
    {
        let prevIndex = LocalidadesDataManager.localidadSelected
        if (prevIndex >= 0) {
            localidades[prevIndex].selected = false
        }
        LocalidadesDataManager.localidadSelected = index
        localidades[index].selected = true
        saveData()
        fetchData()
    }
    
    func setLocalidad(localidad: Localidad, at index: Int)
    {
        localidades[index] = localidad
        saveData()
        fetchData()
    }
    
    
    func countLocalidades() -> Int {
        return localidades.count
    }
    
    
    
    func deleteLocalidad(at indice: Int) {
        let prevIndex = LocalidadesDataManager.localidadSelected
        if (prevIndex == indice) {
            LocalidadesDataManager.localidadSelected = -1
        }
        deleteLocalidad(localidad: localidades[indice])
    }
    

    func deleteLocalidad(localidad: Localidad) {
        context.delete(localidad)
        saveData()
        fetchData()
    }
    
 
    func fetchData()
    {
        do{
            self.localidades = try self.context.fetch(Localidad.fetchRequest())
        }
        catch{
            print("ERROR: No se puede acceder a la base de datos de localidades: ", error.localizedDescription)
        }
    }
    
    
    func saveData()
    {
        do{
            try self.context.save()
        }
        catch{
            print("ERROR: No se puede acceder a salvar la base de datos de localidades: ", error.localizedDescription)
        }
    }

}
