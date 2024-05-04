//
//  EmptySneakerView.swift
//  Steps
//
//  Created by Ciaran Murphy on 5/4/24.
//

import SwiftUI

struct EmptySneakerView: View {
    @Binding var showingShoeSheet: Bool

    var body: some View {
        Button(action: {
            showingShoeSheet = true
            // Note: The following line will result in an error because `sneaker` is not accessible here.
            // print("Sneaker loaded \(sneaker.sneakerLoaded)")
        }) {
            ContentUnavailableView("No sneakers loaded", systemImage: "shoe.2.fill", description: Text("Tap to add your sneakers!"))
        }
    }
}


struct EmptySneakerView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySneakerView(showingShoeSheet: .constant(false))
    }
}
