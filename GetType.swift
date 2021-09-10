//
//  GetType.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/14/21.
//

import Foundation

class GetType {
    
    func getType(typeRequested: Int) -> String {
        switch typeRequested {
        case 1:
            return "Producer"
        case 2:
            return "Rapper"
        case 3:
            return "Sample Artist"
        default:
            return "Not Valid"
        }
    }
}
