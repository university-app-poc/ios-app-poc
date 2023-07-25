//
//  SearchView.swift
//  university-app-poc
//
//  Created by Taha Chaudhry on 13/07/2023.
//
//


import SwiftUI
import CoreData

struct ParsedUniversity {
    var id: Int16
    var name: String
    var address: String
    var contact: ParsedContact?
}

struct ParsedCourse {
    var id: Int16
    var name: String
    var courseDescription: String
    var duration: String
    var entryRequirements: String
    var university: ParsedUniversity
}

struct ParsedContact {
    let email: String
    let phone: String
}

struct SearchView: View {
    @State private var universities: [ParsedUniversity] = []
    @State private var courses: [ParsedCourse] = []
    @State private var savedUniversities: [University] = []
    @State private var savedCourses: [Course] = []
    @State private var searchText = ""
    @State private var searchScope: SearchScope = .university
    @State private var isDataFetched = false

    enum SearchScope: String, CaseIterable {
        case university, course
    }

    var filteredUniversities: [ParsedUniversity] {
        if searchText.isEmpty {
            return universities
        } else {
            return universities.filter { university in
                university.name.localizedCaseInsensitiveContains(searchText) ||
                university.address.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var filteredCourses: [ParsedCourse] {
        if searchText.isEmpty {
            return courses
        } else {
            return courses.filter { course in
                course.name.localizedCaseInsensitiveContains(searchText) ||
                course.university.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }


    var body: some View {
        NavigationView {
            List {
                if searchScope == .university {
                    ForEach(filteredUniversities, id: \.id) { university in
                        NavigationLink(destination: UniversityDetailView(university: university)) {
                            VStack(alignment: .leading) {
                                Text(university.name)
                                    .font(.headline)
                                Text(university.address)
                                    .font(.subheadline)
                            }
                            .contextMenu {
                                Button(action: {
                                    toggleSaveUniversity(university)
                                }) {
                                    Label("Save/Unsave", systemImage: "bookmark")
                                }
                            }
                        }
                    }
                } else {
                    ForEach(filteredCourses, id: \.id) { course in
                        NavigationLink(destination: CourseDetailView(course: course)) {
                            VStack(alignment: .leading) {
                                Text(course.name)
                                    .font(.headline)
                                Text(course.university.name)
                                    .font(.subheadline)
                            }
                            .contextMenu {
                                Button(action: {
                                    toggleSaveCourse(course)
                                }) {
                                    Label("Save/Unsave", systemImage: "bookmark")
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: searchScope == .university ? "Universities..." : "Courses...")
            .onChange(of: searchText) { newValue in
                if newValue.isEmpty {
                    searchScope = .university
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(SearchScope.allCases, id: \.self) { scope in
                            Button(action: {
                                searchScope = scope
                            }) {
                                Label(scope.rawValue.capitalized, systemImage: searchScope == scope ? "checkmark" : "")
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .imageScale(.large)
                    }
                }
            }
        }
        .onAppear {
            if !isDataFetched {
                fetchUniversities()
                fetchCourses()
                isDataFetched = true
            }
        }
    }

    func fetchUniversities() {
        guard let url = URL(string: "http://localhost:8080/universities") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }

            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    DispatchQueue.main.async {
                        self.parseUniversities(jsonArray)
                    }
                }
            } catch {
                print("Error decoding universities: \(error)")
            }
        }.resume()
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
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    DispatchQueue.main.async {
                        self.parseCourses(jsonArray)
                    }
                }
            } catch {
                print("Error decoding courses: \(error)")
            }
        }.resume()
    }
    
    private func parseUniversities(_ jsonArray: [[String: Any]]) {
        for universityData in jsonArray {
            let id = universityData["id"] as? Int16 ?? 0
            let name = universityData["name"] as? String ?? ""
            let address = universityData["address"] as? String ?? ""
            
            var contact: ParsedContact?
            if let contactData = universityData["contact"] as? [String: Any] {
                let email = contactData["email"] as? String ?? ""
                let phone = contactData["phone"] as? String ?? ""
                contact = ParsedContact(email: email, phone: phone)
            }
            
            let parsedUniversity = ParsedUniversity(id: id, name: name, address: address, contact: contact)
            universities.append(parsedUniversity)
        }
    }
    
    private func parseCourses(_ jsonArray: [[String: Any]]) {
        for courseData in jsonArray {
            let id = courseData["id"] as? Int16 ?? 0
            let name = courseData["name"] as? String ?? ""
            let courseDescription = courseData["description"] as? String ?? ""
            let duration = courseData["duration"] as? String ?? ""
            let entryRequirements = courseData["entryRequirements"] as? String ?? ""
            
            var parsedUniversity: ParsedUniversity?
            if let universityData = courseData["university"] as? [String: Any] {
                let universityId = universityData["id"] as? Int16 ?? 0
                let universityName = universityData["name"] as? String ?? ""
                let universityAddress = universityData["address"] as? String ?? ""
                
                var contact: ParsedContact?
                if let contactData = universityData["contact"] as? [String: Any] {
                    let email = contactData["email"] as? String ?? ""
                    let phone = contactData["phone"] as? String ?? ""
                    contact = ParsedContact(email: email, phone: phone)
                }
                
                parsedUniversity = ParsedUniversity(id: universityId, name: universityName, address: universityAddress, contact: contact)
            }
            
            let parsedCourse = ParsedCourse(id: id, name: name, courseDescription: courseDescription, duration: duration, entryRequirements: entryRequirements, university: parsedUniversity!)
            courses.append(parsedCourse)
        }
    }
    
    private func toggleSaveUniversity(_ university: ParsedUniversity) {
        let context = PersistenceController.shared.container.viewContext
        
        let savedUniversityIds = Set(context
            .registeredObjects
            .compactMap { ($0 as? University)?.id }
        )
        
        if savedUniversityIds.contains(university.id) {
            deleteUniversity(university)
        } else {
            saveUniversity(university)
        }
    }
    
    private func toggleSaveCourse(_ course: ParsedCourse) {
        let context = PersistenceController.shared.container.viewContext

        let savedCourseIds = Set(context
            .registeredObjects
            .compactMap { ($0 as? Course)?.id }
        )

        if savedCourseIds.contains(course.id) {
            deleteCourse(course)
        } else {
            saveCourse(course)
        }
    }
    
    private func deleteUniversity(_ university: ParsedUniversity) {
        let context = PersistenceController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "university.id == %d", university.id)
        
        do {
            let coursesToDelete = try context.fetch(fetchRequest)
            for course in coursesToDelete {
                context.delete(course)
            }
            
            let universityFetchRequest: NSFetchRequest<University> = University.fetchRequest()
            universityFetchRequest.predicate = NSPredicate(format: "id == %d", university.id)
            let universities = try context.fetch(universityFetchRequest)
            if let universityToDelete = universities.first {
                context.delete(universityToDelete)
                try context.save()
            }
        } catch {
            print("Error deleting university: \(error)")
        }
    }

    
    func deleteCourse(_ course: ParsedCourse) {
        let context = PersistenceController.shared.container.viewContext

        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", course.id)

        do {
            let courses = try context.fetch(fetchRequest)
            if let courseToDelete = courses.first {
                context.delete(courseToDelete)
                try context.save()
            }
        } catch {
            print("Error deleting course: \(error)")
        }
    }


    
    
    private func saveUniversity(_ university: ParsedUniversity) {
        let context = PersistenceController.shared.container.viewContext
        let savedUniversity = University(context: context)
        savedUniversity.id = university.id
        savedUniversity.name = university.name
        savedUniversity.address = university.address
        
        if let contact = university.contact {
            let savedContact = Contact(context: context)
            savedContact.email = contact.email
            savedContact.phone = contact.phone
            savedUniversity.contact = savedContact
        }
        
        try? context.save()
        savedUniversities.append(savedUniversity)
    }
    
    private func saveCourse(_ course: ParsedCourse) {
        let context = PersistenceController.shared.container.viewContext
        let savedCourse = Course(context: context)
        savedCourse.id = course.id
        savedCourse.name = course.name
        savedCourse.courseDescription = course.courseDescription
        savedCourse.duration = course.duration
        savedCourse.entryRequirements = course.entryRequirements
        
        let fetchRequest: NSFetchRequest<University> = University.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", course.university.id)

        var savedUniversity: University!

        do {
            let universities = try context.fetch(fetchRequest)
            if let existingUniversity = universities.first {
                savedUniversity = existingUniversity
            } else {
                savedUniversity = University(context: context)
                savedUniversity.id = course.university.id
                savedUniversity.name = course.university.name
                savedUniversity.address = course.university.address

                if let contact = course.university.contact {
                    let savedContact = Contact(context: context)
                    savedContact.email = contact.email
                    savedContact.phone = contact.phone
                    savedUniversity.contact = savedContact
                }
            }

            savedCourse.university = savedUniversity
            try context.save()
            savedCourses.append(savedCourse)
        } catch {
            print("Error saving course: \(error)")
        }
    }

}


struct UniversityDetailView: View {
    let university: ParsedUniversity

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                GroupBox {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Address")
                                .font(.headline)
                            Spacer()
                            Text(university.address)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.vertical, 8)

                GroupBox {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Contact Information")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }

                        Divider().padding(.vertical, 4)

                        HStack {
                            Text("Email")
                                .font(.body)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(university.contact!.email)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.trailing)
                        }

                        HStack {
                            Text("Phone")
                                .font(.body)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(university.contact!.phone)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(university.name)
    }
}


struct CourseDetailView: View {
    let course: ParsedCourse
    @State private var isUniversityTapped = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(course.name)
                            .font(.headline)
                        Text(course.courseDescription)
                            .font(.subheadline)
                    }
                }

                GroupBox {
                    NavigationLink(destination: UniversityDetailView(university: course.university), isActive: $isUniversityTapped) {
                        HStack {
                            Text("University")
                                .font(.headline)
                            Image(systemName: "info.circle")
                        }
                        .onTapGesture {
                            isUniversityTapped = true
                        }
                    }.buttonStyle(PlainButtonStyle())

                    Divider().padding(.vertical, 4)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Entry Requirements")
                                .font(.headline)
                            Spacer()
                            Text(course.entryRequirements)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 8)
                        .groupBoxStyle(DefaultGroupBoxStyle())

                        HStack {
                            Text("Duration")
                                .font(.headline)
                            Spacer()
                            Text(course.duration)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 8)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(course.name)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
