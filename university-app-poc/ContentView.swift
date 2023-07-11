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
    private var singleTabWidth = UIScreen.main.bounds.width / 5
    
    var body: some View {
        TabView(selection: $selectedTab) {
            UniversityListView()
                .tabItem {
                    VStack{
                        Image(systemName: "house.lodge.circle")
                        Text("Search")
                    }
                }
            
            CourseListView()
                .tabItem {
                    VStack{
                        Image(systemName: "book.closed.fill")
                        Text("Courses").bold()
                    }
                }
            // SavedCoursesListView()
            Text("")
                .tabItem {
                    VStack{
                        Image(systemName: "books.vertical.fill")
                        Text("Saved Courses")
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
