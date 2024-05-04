//  MySneakers.swift
//  Steps
//
//  Created by Ciaran Murphy on 4/22/24.
//

import SwiftUI

// Define a view to manage sneaker details
struct MySneakers: View {
    // Environment property for dismissing the view
    @Environment(\.dismiss) var dismiss
    // State properties for managing user input
    @State private var purchaseDate: Date
    @State private var shoeNickname = ""
    @State private var life = 300.0
    @ObservedObject var sneaker: Sneaker
    @State private var showingDeleteAlert = false
    
    // Key for storing sneaker data in UserDefaults
    let sneakersKey = "Sneakers"
    
    // Initialize the view with a sneaker object
    init(sneaker: Sneaker) {
        self.sneaker = sneaker
        _purchaseDate = State(initialValue: sneaker.purchaseDate)
        _shoeNickname = State(initialValue: sneaker.shoeName)
        _life = State(initialValue: sneaker.life)
        }
    
    // Body of the view
    var body: some View {
        NavigationView{
            Form{
                VStack {
                    // Date picker for selecting purchase date
                    DatePicker("Purchase Date:", selection: $purchaseDate, displayedComponents: .date)
                        .padding()
                    
                    HStack{
                        // Text field for entering shoe nickname
                        Text("Shoe Nickname:")
                        TextField("My Shoe", text: $shoeNickname)
                            .padding()
                            .border(Color.primary)
                    }
                    .padding()
                    
                    HStack{
                        // Text field for entering maximum distance a shoe should travel
                        Text("Max Distance: ")
                        TextField("", value: $life, format: .number)
                            .keyboardType(.decimalPad)
                            .padding()
                            .border(Color.primary)
                        Text("miles")
                    }
                    .padding()
                    
                    
                    // Button to save sneaker details
                    Button("Save"){
                        save()
                    }
                    .padding()
                    .bold()
                }
            }
            // Toolbar items for navigation bar

            .toolbar{
                // Button to dismiss the view
                ToolbarItem(placement: .cancellationAction){
                    Button("Dismiss"){
                        print("Dismissing")
                        dismiss()
                    }
                    .bold()
                }
                
                // Button to remove sneaker
                if sneaker.sneakerLoaded == true {
                    ToolbarItem(placement: .destructiveAction){
                        Button("Remove Sneaker", role: .destructive){
                            showingDeleteAlert = true
                            //removeSneaker()
                        }
                        .bold()
                        .foregroundStyle(.red)
                    }
                }
                    
        }
            // Alert for confirming sneaker deletion
            .alert(isPresented: $showingDeleteAlert){
                Alert(
                    title: Text("Are you sure you want to delete this sneaker?"),
                      message: Text("This can't be undone"),
                    primaryButton: .destructive(Text("Delete")) {
                        removeSneaker()
                    },
                    secondaryButton: .default(Text("Cancel")))
            }
        
        }
    }
    // Function to save sneaker details
    func save() {
        sneaker.sneakerLoaded = true
        print(sneaker.sneakerLoaded)
        sneaker.purchaseDate = purchaseDate
        sneaker.shoeName = shoeNickname
        sneaker.life = life
        let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(sneaker) {
                UserDefaults.standard.set(encoded, forKey: sneakersKey)
            }
        dismiss()
    }
    
    // Function to remove sneaker
    func removeSneaker() {
        sneaker.sneakerLoaded = false
        UserDefaults.standard.removeObject(forKey: sneakersKey)
        print("function: \(sneaker.sneakerLoaded)")
        sneaker.purchaseDate = Date()
        sneaker.shoeName =  ""
        sneaker.life = 300
        dismiss()
    }
}

/*#Preview {
    MySneakers(sneaker: $Sneaker.exampleSneaker)
}*/
