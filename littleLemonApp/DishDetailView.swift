//
//  DishDetailView.swift
//  littleLemonApp
//
//  Created by Daniel Bauer on 10.05.24.
//

import SwiftUI

struct DishDetailView: View {
    let dish: Dish
    
    var body: some View {
        VStack {
            Text(dish.title ?? "")
                .font(.title)
            Text("$\(dish.price ?? "")")
                .font(.headline)
                .padding(.bottom, 20)
            AsyncImage(url: URL(string: dish.image ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                default:
                    ProgressView()
                }
            }
        }
        .padding()
        .navigationBarTitle(Text("Dish Details"))
    }
}
