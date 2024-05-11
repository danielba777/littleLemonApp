import SwiftUI
import CoreData

struct Menu: View {
    
    @State private var searchText = ""
    @State private var selectedCategory: String? 
    @State private var dataLoaded = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var dishes: FetchedResults<Dish>
    
    let categories = ["All", "starters", "mains", "desserts"]
    
    init() {
        let request: NSFetchRequest<Dish> = Dish.fetchRequest()
        request.sortDescriptors = buildSortDescriptors()
        request.predicate = buildPredicate()
        _dishes = FetchRequest(fetchRequest: request, animation: .default)
    }
    
    var body: some View {
        VStack{
            Header()
            VStack{
                Text("Little Lemon")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("Primary02"))
                    .padding(.top, 20)
                    .font(Font.custom("Markazi Text", size: 64))
                Text("Chicago")
                    .font(.title2)
                    .foregroundStyle(Color("Secondary03"))
                Text("This app is for our lovely customers who want to get their favorite meal in our Little Lemon Restaurant. See you soon! 😊")
                    .padding(10)
                    .foregroundStyle(Color("Secondary03"))
                TextField("Search menu", text: $searchText)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(20)
                
            }
            .background(Color("Primary01"))
            .padding(.bottom, 10)
            Text("Order for Delivery")
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category == "All" ? nil : category
                    }) {
                        Text(category.capitalized)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(selectedCategory == category ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.vertical, 10)
            
            List {
                ForEach(filteredDishes, id: \.self) { dish in
                    NavigationLink(destination: DishDetailView(dish: dish)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(dish.title ?? "")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text(dish.descrip ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("$\(dish.price ?? "")")
                                    .font(.headline)
                            }
                            Spacer()
                            AsyncImage(url: URL(string: dish.image ?? "")) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Rectangle())
                                        .frame(width: 100, height: 100)
                                default:
                                    ProgressView()
                                }
                            }
                        }
                        .padding(8)
                    }
                }
            }
        }.onAppear(){
            if !dataLoaded {
                getMenuData()
                dataLoaded = true
            }
        }
    }
    
    // Filter dishes based on selected category
    var filteredDishes: [Dish] {
        if let selectedCategory = selectedCategory, selectedCategory != "All" {
            return dishes.filter { $0.category == selectedCategory }
        } else {
            return Array(dishes)
        }
    }
    
    func getMenuData(){
        PersistenceController.shared.clear()
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        
        guard let url = URL(string: urlString) else{
            print("invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data else{
                if let error = error{
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            do{
                let menuList = try JSONDecoder().decode(MenuList.self, from:data)
                print(menuList)
                
                for menuItem in menuList.menu{
                    let dish = Dish(context: viewContext)
                    dish.title = menuItem.title
                    dish.image = menuItem.image
                    dish.price = menuItem.price
                    dish.descrip = menuItem.description
                    dish.category = menuItem.category
                }
                
                try? viewContext.save()
                
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}



func buildSortDescriptors() -> [NSSortDescriptor] {
    return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
}

func buildPredicate() -> NSPredicate {
    return NSPredicate(value: true)
}

#Preview {
    Menu()
}

