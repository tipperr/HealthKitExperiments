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
//    @State private var exampleSneaker = Sneaker.exampleSneaker
    //@State var sneaker: Sneaker
    @Binding var sneaker: Sneaker
    //@State private var sneakerLoaded = false
    
    var body: some View {
        NavigationView{
            Form{
                VStack {
                    DatePicker("Purchase Date:", selection: $purchaseDate, displayedComponents: .date)
                        .padding()
                    
                    HStack{
                        Text("Shoe Nickname:")
                        TextField("My Shoe", text: $shoeNickname)
                            .padding()
                            .border(Color.primary)
                    }
                    .padding()
                    
                    HStack{
                        Text("Max Distance: ")
                        
                        TextField("", value: $life, format: .number)
                            .keyboardType(.decimalPad)
                            .padding()
                            .border(Color.primary)
                        Text("miles")
                    }
                    .padding()
                    
                    
                    
                    Button("Save"){
                        //sneakerLoaded = true
                        //sneakerLoaded.toggle()
                        //sneaker.sneakerLoaded = true
                        //print("Sneaker loaded? \(sneakerLoaded)")
                        save()
                        //dismiss()
                    }
                    .padding()
                    .bold()
                    
//                    Button("Remove Sneaker"){
//                        removeSneaker()
//                    }
                }
            }
            .toolbar{
                Button("Dismiss"){
                    print("Dismissing")
                    dismiss()
                }
                .bold()
        }
        
        }
    }
    
    func save() {
        sneaker.sneakerLoaded = true
        print(sneaker.sneakerLoaded)
        sneaker.purchaseDate = purchaseDate
        sneaker.shoeName = shoeNickname
        sneaker.life = life
        dismiss()
    }
    
    func removeSneaker() {
        sneaker.sneakerLoaded = false
        sneaker.purchaseDate = Date()
        sneaker.shoeName = ""
        sneaker.life = 300
        dismiss()
    }
}

/*#Preview {
    MySneakers(sneaker: $Sneaker.exampleSneaker)
}*/
