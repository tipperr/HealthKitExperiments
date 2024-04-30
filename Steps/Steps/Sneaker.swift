//  Sneaker.swift
//  Steps
//
//  Created by Ciaran Murphy on 4/22/24.
//

import SwiftUI

class Sneaker: ObservableObject, Codable {
    @Published var purchaseDate: Date
    @Published var shoeName: String
    @Published var life: Double
    @Published var sneakerLoaded: Bool
    
    enum CodingKeys: String, CodingKey {
            case purchaseDate
            case shoeName
            case life
            case sneakerLoaded
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            purchaseDate = try container.decode(Date.self, forKey: .purchaseDate)
            shoeName = try container.decode(String.self, forKey: .shoeName)
            life = try container.decode(Double.self, forKey: .life)
            sneakerLoaded = try container.decode(Bool.self, forKey: .sneakerLoaded)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(purchaseDate, forKey: .purchaseDate)
            try container.encode(shoeName, forKey: .shoeName)
            try container.encode(life, forKey: .life)
            try container.encode(sneakerLoaded, forKey: .sneakerLoaded)
        }
    
    init(purchaseDate: Date, shoeName: String, life: Double, sneakerLoaded: Bool) {
        self.purchaseDate = purchaseDate
        self.shoeName = shoeName
        self.life = life
        self.sneakerLoaded = sneakerLoaded
    }
    
    static let exampleSneaker = Sneaker(purchaseDate: Date(), shoeName: "Example", life: 300, sneakerLoaded: true)

    
//    static let exampleSneaker: Sneaker = {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            
//            guard let date = dateFormatter.date(from: "2023-04-16") else {
//                fatalError("Failed to create a Date object from the string")
//            }
//            
//            return Sneaker(purchaseDate: date, shoeName: "Brooks Ghost", life: 300, sneakerLoaded: true)
//        }()
}
