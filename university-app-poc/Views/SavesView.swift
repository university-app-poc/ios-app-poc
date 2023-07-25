//
//  SavesView.swift
//  university-app-poc
//
//  Created by Taha Chaudhry on 17/07/2023.
//
//

import SwiftUI
import CoreData

struct SavesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \University.name, ascending: true)],
        animation: .default)
    private var universities: FetchedResults<University>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default)
    private var courses: FetchedResults<Course>

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Universities")) {
                        ForEach(universities) { university in
                            var parsedUniversity = ParsedUniversity(id: university.id, name: university.name, address: university.address, contact: ParsedContact(email: university.contact.email, phone: university.contact.phone))
                            
                            NavigationLink(destination: UniversityDetailView(university: parsedUniversity)) {
                                VStack(alignment: .leading) {
                                    Text(university.name)
                                        .font(.headline)
                                    Text(university.contact.email)
                                        .font(.subheadline)
                                }
                                .contextMenu {
                                    Button(action: {
                                        deleteUniversity(university)
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }

                    Section(header: Text("Courses")) {
                        ForEach(courses) { course in
                            var parsedCourse = ParsedCourse(id: course.id, name: course.name, courseDescription: course.courseDescription, duration: course.duration, entryRequirements: course.entryRequirements, university: ParsedUniversity(id: course.university.id, name: course.university.name, address: course.university.address, contact: ParsedContact(email: course.university.contact.email, phone: course.university.contact.phone)))
                            
                            NavigationLink(destination: CourseDetailView(course: parsedCourse)) {
                                VStack(alignment: .leading) {
                                    Text(course.name)
                                        .font(.headline)
                                    Text(course.university.name)
                                        .font(.subheadline)
                                }
                                .contextMenu {
                                    Button(action: {
                                        deleteCourse(course)
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Core Data")
        }
    }

    private func deleteUniversity(_ university: University) {
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "university.id == %d", university.id)
        
        do {
            let coursesToDelete = try viewContext.fetch(fetchRequest)
            for course in courses {
                viewContext.delete(course)
            }
            
            let universityFetchRequest: NSFetchRequest<University> = University.fetchRequest()
            universityFetchRequest.predicate = NSPredicate(format: "id == %d", university.id)
            let universities = try viewContext.fetch(universityFetchRequest)
            if let universityToDelete = universities.first {
                viewContext.delete(universityToDelete)
                saveContext()
            }
        } catch {
            print("Error deleting university: \(error)")
        }
    }

    private func deleteCourse(_ course: Course) {
        viewContext.delete(course)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct SavesView_Previews: PreviewProvider {
    static var previews: some View {
        SavesView()
    }
}
