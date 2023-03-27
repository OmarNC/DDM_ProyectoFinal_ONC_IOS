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
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetch(){
        do{
            self.localidades = try self.context.fetch(Localidad.fetchRequest())
        }
        catch{
            print("ERROR: No se ha podido leer la base de datos")
        }
    }
    
    func getLocalidad(at index: Int) -> Localidad {
        
        return localidades[index]
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
