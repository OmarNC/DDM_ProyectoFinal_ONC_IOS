//
//  Helper.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 23/03/23.
//


import Foundation
import UIKit

class Helper
{
    
    static func dateTimeToString(unixTimestamp: Double, format: String) -> String
    {
        let date = Date(timeIntervalSince1970: unixTimestamp)
        return dateTimeToString(date: date, format: format)
    }
    
    static func dateTimeToString(date: Date, format: String) -> String
    {
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        //dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
   
    
    static let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter
    }()
    
    
    static func validateText(text : String) -> Bool{
        if (text.trimmingCharacters(in: .whitespaces).isEmpty) {
            return false
        }
        return true
    }
    
    static func validateTextNumeber(text : String) -> Bool{
        let value = Double(text)
        
        if (value == nil) {
            return false
        }
        return true
    }
    
    
    static func AlertMessageOk(title : String?, message : String, viewController : UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("ALERT_OK", comment: "ALERT_OK"), style: .default)
        alert.addAction(alertAction)
        viewController.present(alert, animated: true)
    }
}

