//
//  ResponseToGetJSONProtocol.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 26/03/23.
//

import Foundation

protocol ResponseToGetJSONDelegate {
    func responseComplationHandler()
    func networkUnavailableAction()
    func requestFailedAction(error: Any)
    func decodeJSONErrorAction(error: Any)
    
}
