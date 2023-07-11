//
//  CourseListView.swift
//  university-app-poc
//
//  Created by Taha Chaudhry on 11/07/2023.
//

import SwiftUI

struct Course: Codable {
    let id: Int
    let name: String
    let university: University
    // Add more university properties
}

struct CourseListView: View {
    @State private var courses: [Course] = []
    @State private var isEditing = false
    @State private var searchText = ""

    var filteredCourses: [Course] {
        if searchText.isEmpty {
            return courses
        } else {
            return courses.filter { course in
                course.name.localizedCaseInsensitiveContains(searchText) ||                 course.university.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack {
            SearchBar(text: $searchText, isEditing: $isEditing)
            
            if isEditing {
                List(filteredCourses, id: \.id) { course in
                    VStack(alignment: .leading) {
                        Text(course.name)
                            .font(.headline)
                        Text(course.university.name)
                            .font(.subheadline)
                    }
                }
            } else {
                Spacer()
            }
        }
        .onAppear {
            fetchCourses()
        }
    }

    func fetchCourses() {
        guard let url = URL(string: "http://localhost:8080/courses") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }

            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self.courses = courses
                }
            } catch {
                print("Error decoding courses: \(error)")
            }
        }.resume()
    }
}
