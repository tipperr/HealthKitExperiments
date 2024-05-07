//
//  MySneakersButtonView.swift
//  Steps
//
//  Created by Ciaran Murphy on 5/4/24.
//

import SwiftUI

struct MySneakersButtonView: View {
    @Binding var showingShoeSheet: Bool

    var body: some View {
        Button("My Sneakers", systemImage: "shoe.fill") {
                    showingShoeSheet = true
                }    }
}

#Preview {
    MySneakersButtonView(showingShoeSheet: .constant(false))
}
