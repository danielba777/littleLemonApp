import SwiftUI

struct DishDetailView: View {
    let dish: Dish
    
    var body: some View {
        VStack {
            Text(dish.title ?? "")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            AsyncImage(url: URL(string: dish.image ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10) 
                default:
                    ProgressView()
                }
            }
            
            // Beschreibung und Preis
            VStack(alignment: .leading, spacing: 8) {
                Text("Price: $\(dish.price ?? "")")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(dish.descrip ?? "")
                    .font(.body)
            }
            .padding()
        }
        .navigationBarTitle(Text("Dish Details"))
    }
}
