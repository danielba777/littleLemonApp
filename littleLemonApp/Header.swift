//
//  Header.swift
//  littleLemonApp
//
//  Created by Daniel Bauer on 10.05.24.
//

import SwiftUI

struct Header: View {
    var body: some View {
        HStack {
            Spacer() // Fügt einen leeren Bereich ganz links hinzu
            Image("Logo")
                .padding(.leading, 50) // Verschiebt das Logo um 50 Punkte nach rechts
            Spacer() // Fügt einen leeren Bereich zwischen dem Logo und dem Profilbild hinzu
            Image("profile-image-placeholder")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                .padding(.trailing, 20) // Fügt einen Abstand zwischen dem Profilbild und dem rechten Rand hinzu
        }
    }
}




#Preview {
    Header()
}
