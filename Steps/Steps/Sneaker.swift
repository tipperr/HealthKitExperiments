//
//  Sneaker.swift
//  Steps
//
//  Created by Ciaran Murphy on 4/22/24.
//

import SwiftUI

struct Sneaker {
    var purchaseDate: Date
    var shoeName: String
    
    static let exampleSneaker: Sneaker = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            guard let date = dateFormatter.date(from: "2024-04-22") else {
                fatalError("Failed to create a Date object from the string")
            }
            
            return Sneaker(purchaseDate: date, shoeName: "Brooks Ghost")
        }()
}
