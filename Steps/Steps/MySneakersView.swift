//  MySneakers.swift
//  Steps
//
//  Created by Ciaran Murphy on 4/22/24.
//

import SwiftUI

struct MySneakers: View {
    @Environment(\.dismiss) var dismiss
    @State private var purchaseDate = Date()
    @State private var shoeNickname = ""
    @State private var life = 300.0
    @State private var sneaker = Sneaker.exampleSneaker
    @State private var sneakerLoaded = false
    
    var body: some View {
        NavigationView{
            VStack {
                DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
                    .padding()
                
                HStack{
                    Text("Shoe Nickname")
                    TextField("Shoe Nickname", text: $shoeNickname)
                        .padding()
                }
                .padding()
                
                HStack{
                    Text("Maximum Distance: ")
                    TextField("Maximum Distance", value: $life, format: .number)
                        .keyboardType(.decimalPad)
                    Text("miles")
                }
                .padding()
                
                Button("Save"){
                    sneakerLoaded = true
                    save()
                    //dismiss()
                }
                .padding()
                .bold()
            }
            .toolbar{
                Button("Dismiss"){
                    dismiss()
                }
                .bold()
        }
        
        }
    }
    
    func save() {
        sneakerLoaded = true
        dismiss()
    }
}

#Preview {
    MySneakers()
}
