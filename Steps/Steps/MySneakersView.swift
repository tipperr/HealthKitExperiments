//  MySneakers.swift
//  Steps
//
//  Created by Ciaran Murphy on 4/22/24.
//

import SwiftUI

struct MySneakers: View {
    @Environment(\.dismiss) var dismiss
    @State private var purchaseDate: Date //= sneaker.purchaseDate //= Date()
    @State private var shoeNickname = ""
    @State private var life = 300.0
//    @State private var exampleSneaker = Sneaker.exampleSneaker
    //@State var sneaker: Sneaker
    //@Binding var sneaker: Sneaker
    @ObservedObject var sneaker: Sneaker
    @State private var showingDeleteAlert = false
    //var onRemoveSneaker: () -> Void
    //@State private var sneakerLoaded = false
    
    let sneakersKey = "Sneakers"
    
    init(sneaker: Sneaker) {
        self.sneaker = sneaker
        _purchaseDate = State(initialValue: sneaker.purchaseDate)
        _shoeNickname = State(initialValue: sneaker.shoeName)
        _life = State(initialValue: sneaker.life)
        }
    
//    init(sneaker: Binding<Sneaker>) {
//            _sneaker = sneaker
//            _purchaseDate = State(initialValue: sneaker.wrappedValue.purchaseDate)
//            _shoeNickname = State(initialValue: sneaker.wrappedValue.shoeName)
//            _life = State(initialValue: sneaker.wrappedValue.life)
//        }
    
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
                    
                    //Button("Remove Sneaker", action: removeSneaker)//{
                        //print("button: \(sneaker.sneakerLoaded)")
                        //removeSneaker()
                    //}
                }
            }
            .toolbar{
                ToolbarItem(placement: .cancellationAction){
                    Button("Dismiss"){
                        print("Dismissing")
                        dismiss()
                    }
                    .bold()
                }
                
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
    
    
    func removeSneaker() {
        sneaker.sneakerLoaded = false
        UserDefaults.standard.removeObject(forKey: sneakersKey)
        print("function: \(sneaker.sneakerLoaded)")
        sneaker.purchaseDate = Date()
        sneaker.shoeName =  ""
        sneaker.life = 300
//        sneaker.purchaseDate = purchaseDate
//        sneaker.shoeName = shoeNickname
//        sneaker.life = life
//        onRemoveSneaker()
        //sneaker = Sneaker(purchaseDate: Date(), shoeName: "", life: 300, sneakerLoaded: false)
        dismiss()
    }
}

/*#Preview {
    MySneakers(sneaker: $Sneaker.exampleSneaker)
}*/
