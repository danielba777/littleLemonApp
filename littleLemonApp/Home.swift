//
//  Home.swift
//  littleLemonApp
//
//  Created by Daniel Bauer on 09.05.24.
//

import SwiftUI

struct Home: View {
    
    let persistence = PersistenceController.shared
    
    var body: some View {
        TabView{
            Menu()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .tabItem{
                    Label("Menu", systemImage: "list.dash")
                }
            UserProfile()
                .tabItem{
                    Label("Profile", systemImage: "square.and.pencil")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Home()
}
