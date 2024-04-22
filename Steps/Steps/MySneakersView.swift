//
//  MySneakers.swift
//  Steps
//
//  Created by Ciaran Murphy on 4/22/24.
//

import SwiftUI

struct MySneakers: View {
    @State private var purchaseDate = Date()
    @State private var shoeNickname = ""
    @State private var sneaker = Sneaker.exampleSneaker
    
    var body: some View {
        
        VStack {
            DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
                .padding()
            
            TextField("Shoe Nickname", text: $shoeNickname)
                .padding()
        }
    }
}

#Preview {
    MySneakers()
}
