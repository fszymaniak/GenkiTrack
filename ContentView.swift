import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject private var dietManager = DietManager()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DiaryView()
                .environmentObject(dietManager)
                .tabItem {
                    Image(systemName: "book.closed")
                    Text("Dzienniczek")
                }
                .tag(0)
            
            ChatView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Czat")
                }
                .tag(1)
            
            ShoppingListView()
                .environmentObject(dietManager)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Zakupy")
                }
                .badge(8)
                .tag(2)
            
            MoreView()
                .environmentObject(dietManager)
                .tabItem {
                    Image(systemName: "ellipsis")
                    Text("Więcej")
                }
                .tag(3)
        }
        .accentColor(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
