//
//  Localidad+CoreDataProperties.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 25/03/23.
//
//

import Foundation
import CoreData


extension Localidad {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Localidad> {
        return NSFetchRequest<Localidad>(entityName: "Localidad")
    }

    @NSManaged public var country: String?
    @NSManaged public var descripcion: String?
    @NSManaged public var image_src: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var state: String?
    @NSManaged public var selected: Bool

}

extension Localidad : Identifiable {

}
