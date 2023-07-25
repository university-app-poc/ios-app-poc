//
//  ContentView.swift
//  university-app-poc
//
//  Created by Taha Chaudhry on 11/07/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State public var selectedTab = 0
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView()
                .tabItem {
                    VStack{
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                }
            SavesView()
                .tabItem {
                    VStack{
                        Image(systemName: "books.vertical.fill")
                        Text("Saved Courses")
                    }
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
