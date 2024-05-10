import SwiftUI
import CoreData

struct Menu: View {
    
    @State private var searchText = ""
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var dishes: FetchedResults<Dish>
    
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
            
            List {
                ForEach(dishes.filter { searchText.isEmpty || $0.title?.localizedCaseInsensitiveContains(searchText) == true }, id: \.self) { dish in
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
            getMenuData()
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

