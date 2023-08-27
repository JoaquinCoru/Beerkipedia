//
//  DateUtils.swift
//  Beerkipedia
//
//  Created by Joaquín Corugedo Rodríguez on 25/8/23.
//

import Foundation


extension Date {
    
    func convertFromDateToFormattedString() -> String {
        var dateString = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        dateString = formatter.string(from: self)
        
        return dateString
    }
    
}
