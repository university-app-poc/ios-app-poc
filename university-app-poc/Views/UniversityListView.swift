//
//  SearchUniversities.swift
//  university-app-poc
//
//  Created by Taha Chaudhry on 11/07/2023.
//
//
//import SwiftUI
//
//struct UniversityListView: View {
//    @State private var universities: [University] = []
//    @State private var searchText = ""
//    @State private var searchScope: SearchScope = .university
//
//    enum SearchScope: String, CaseIterable {
//        case university, course
//    }
//    
//    var filteredUniversities: [University] {
//        if searchText.isEmpty {
//            return universities
//        } else {
//            return universities.filter { university in
//                university.name.localizedCaseInsensitiveContains(searchText) ||
//                university.address.localizedCaseInsensitiveContains(searchText)
//            }
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            List(filteredUniversities, id: \.id) { university in
//                VStack(alignment: .leading) {
//                    Text(university.name)
//                        .font(.headline)
//                    Text(university.address)
//                        .font(.subheadline)
//                }
//            }
//            .navigationTitle("Universities")
//            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search")
//            .onChange(of: searchText) { newValue in
//                if newValue.isEmpty {
//                    searchScope = .university
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .primaryAction) {
//                    Menu {
//                        ForEach(SearchScope.allCases, id: \.self) { scope in
//                            Button(action: {
//                                searchScope = scope
//                            }) {
//                                Label(scope.rawValue.capitalized, systemImage: searchScope == scope ? "checkmark" : "")
//                            }
//                        }
//                    } label: {
//                        Image(systemName: "slider.horizontal.3")
//                            .imageScale(.large)
//                    }
//                }
//            }
//        }
//        .onAppear {
//            fetchUniversities()
//        }
//    }
//
//    func fetchUniversities() {
//        guard let url = URL(string: "http://localhost:8080/universities") else {
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                return
//            }
//
//            do {
//                let universities = try JSONDecoder().decode([University].self, from: data)
//                DispatchQueue.main.async {
//                    self.universities = universities
//                }
//            } catch {
//                print("Error decoding universities: \(error)")
//            }
//        }.resume()
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////import SwiftUI
////
////struct University: Codable {
////    let id: Int
////    let name: String
////    let address: String
////    let contact: Contact
////}
////
////struct Contact: Codable {
////    let email: String
////    let phone: String
////}
////
////struct UniversityListView: View {
////    @State private var universities: [University] = []
////    @State private var isEditing: Bool = false
////    @State private var searchText = ""
////
////    @State private var searchScope: SearchScope = .university
////    enum SearchScope: String, CaseIterable {
////        case university, course
////    }
////
////    var filteredUniversities: [University] {
////        if searchText.isEmpty {
////            return universities
////        } else {
////            return universities.filter { university in
////                university.name.localizedCaseInsensitiveContains(searchText) ||
////                university.address.localizedCaseInsensitiveContains(searchText)
////            }
////        }
////    }
////
////    var body: some View {
////        VStack {
//////            SearchBar(text: $searchText, isEditing: $isEditing)
//////            Picker("Search Mode", selection: $searchScope) {
//////                Text("Universities").tag(SearchScope.university)
//////                Text("Courses").tag(SearchScope.course)
//////            }
////
////            if isEditing {
////                List(filteredUniversities, id: \.id) { university in
////                    VStack(alignment: .leading) {
////                        Text(university.name)
////                            .font(.headline)
////                        Text(university.address)
////                            .font(.subheadline)
////                    }
////                }
////            } else {
////                Spacer()
////            }
////        }
////        .searchable(text: $searchText)
////        .searchScopes($searchScope) {
////            ForEach(SearchScope.allCases, id: \.self) { scope in
////                Text(scope.rawValue.capitalized)
////            }
////        }
////        .onAppear {
////            fetchUniversities()
////        }
////    }
////
////    func fetchUniversities() {
////        guard let url = URL(string: "http://localhost:8080/universities") else {
////            return
////        }
////
////        URLSession.shared.dataTask(with: url) { data, response, error in
////            guard let data = data else {
////                return
////            }
////
////            do {
////                let universities = try JSONDecoder().decode([University].self, from: data)
////                DispatchQueue.main.async {
////                    self.universities = universities
////                }
////            } catch {
////                print("Error decoding universities: \(error)")
////            }
////        }.resume()
////    }
////}
////
////struct SearchBar: View {
////    @Binding var text: String
////    @Binding var isEditing: Bool
////
////
////    var body: some View {
////        HStack {
////            TextField("Search", text: $text, onEditingChanged: { editing in
////                isEditing = editing
////            }, onCommit: {
////                isEditing = false
////            })
////            .padding(.vertical, 8)
////            .padding(.horizontal, 16)
////            .background(Color(.systemGray5))
////            .cornerRadius(8)
////
////            if !text.isEmpty {
////                Button(action: {
////                    text = ""
////                }) {
////                    Image(systemName: "xmark.circle.fill")
////                        .foregroundColor(Color(.systemGray3))
////                        .padding(.horizontal, 8)
////                }
////                .buttonStyle(PlainButtonStyle())
////            }
////        }
////        .padding(.horizontal)
////        .padding(.top)
////    }
////}
