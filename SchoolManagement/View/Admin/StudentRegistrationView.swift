//
//  StudentRegistrationView.swift
//  SchoolManagement
//
//  Created by Sajed Shaikh on 20/11/25.
//

import Combine
import PhotosUI
import SwiftUI

enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}

enum Category: String, CaseIterable {
    case general = "General"
    case obc = "OBC"
    case sc = "SC"
    case st = "ST"
}

enum BloodGroup: String, CaseIterable {
    case aPositive = "A+"
    case aNegative = "A-"
    case bPositive = "B+"
    case bNegative = "B-"
    case abPositive = "AB+"
    case abNegative = "AB-"
    case oPositive = "O+"
    case oNegative = "O-"
}

struct StudentProfile {
    var email = ""
    var password = ""
    var firstName = ""
    var middleName = ""
    var lastName = ""
    var gender = Gender.male.rawValue
    var dateOfBirth = Date()
    var nationality = ""
    var religion = ""
    var category = Category.general.rawValue
    var motherTongue = ""
    var bloodGroup = BloodGroup.oPositive.rawValue
    var studentImage: Data? = nil
    var fatherImage: Data? = nil
    var motherImage: Data? = nil
}

// MARK: - View Model

class UserProfileViewModel: ObservableObject {
    @Published var studentProfile = StudentProfile()

    var age: Int? {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents(
            [.year],
            from: studentProfile.dateOfBirth,
            to: Date()
        )
        return ageComponents.year
    }

    func loadImageFromPickerItem(item: PhotosPickerItem?) {
        guard let item = item else { return }

        // Asynchronously load the data from the item
        Task {
            if let data = try? await item.loadTransferable(type: Data.self) {
                DispatchQueue.main.async {
                    self.studentProfile.studentImage = data
                }
            }
        }
    }

    func loadImageFromPickerItem(
        item: PhotosPickerItem?,
        for keyPath: WritableKeyPath<StudentProfile, Data?>
    ) {
        guard let item = item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self) {
                await MainActor.run {
                    self.studentProfile[keyPath: keyPath] = data
                }
            }
        }
    }
}

struct StudentRegistrationView: View {
    @StateObject private var viewModel = UserProfileViewModel()
    @State private var selectedStudentImageItem: PhotosPickerItem? = nil
    @State private var selectedFatherImageItem: PhotosPickerItem? = nil
    @State private var selectedMotherImageItem: PhotosPickerItem? = nil

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Account Details
                Section(header: Text("Account Details")) {
                    TextField("Email", text: $viewModel.studentProfile.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    SecureField(
                        "Password",
                        text: $viewModel.studentProfile.password
                    )
                }

                // MARK: - Personal Information
                Section(header: Text("Personal Information")) {
                    TextField(
                        "First Name",
                        text: $viewModel.studentProfile.firstName
                    )
                    TextField(
                        "Middle Name",
                        text: $viewModel.studentProfile.middleName
                    )
                    TextField(
                        "Last Name",
                        text: $viewModel.studentProfile.lastName
                    )

                    Picker(
                        "Gender",
                        selection: $viewModel.studentProfile.gender
                    ) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender.rawValue)
                        }
                    }

                    DatePicker(
                        "Date of Birth",
                        selection: $viewModel.studentProfile.dateOfBirth,
                        displayedComponents: .date
                    )

                    if let age = viewModel.age {
                        Text("Age: \(age) years")
                            .foregroundColor(.secondary)
                    }
                }

                // MARK: - Images Section
                Section(header: Text("Images")) {

                    PhotosPickerView(
                        title: "Student Image",
                        imageData: viewModel.studentProfile.studentImage,
                        selectedItem: $selectedStudentImageItem
                    ) { newItem in
                        viewModel.loadImageFromPickerItem(
                            item: newItem,
                            for: \.studentImage
                        )
                    }

                    PhotosPickerView(
                        title: "Father's Image",
                        imageData: viewModel.studentProfile.fatherImage,
                        selectedItem: $selectedFatherImageItem
                    ) { newItem in
                        viewModel.loadImageFromPickerItem(
                            item: newItem,
                            for: \.fatherImage
                        )
                    }

                    PhotosPickerView(
                        title: "Mother's Image",
                        imageData: viewModel.studentProfile.motherImage,
                        selectedItem: $selectedMotherImageItem
                    ) { newItem in
                        viewModel.loadImageFromPickerItem(
                            item: newItem,
                            for: \.motherImage
                        )
                    }

                }

                // MARK: - Other Details
                Section(header: Text("Other Details")) {
                    TextField(
                        "Nationality",
                        text: $viewModel.studentProfile.nationality
                    )

                    TextField(
                        "Religion (Optional)",
                        text: $viewModel.studentProfile.religion
                    )

                    Picker(
                        "Category",
                        selection: $viewModel.studentProfile.category
                    ) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category.rawValue)
                        }
                    }

                    TextField(
                        "Mother Tongue",
                        text: $viewModel.studentProfile.motherTongue
                    )

                    Picker(
                        "Blood Group",
                        selection: $viewModel.studentProfile.bloodGroup
                    ) {
                        ForEach(BloodGroup.allCases, id: \.self) { group in
                            Text(group.rawValue).tag(group.rawValue)
                        }
                    }
                }

                // MARK: - Submit Button (Placeholder for action)
                Section {
                    Button("Submit Registration") {
                        // Handle form submission logic here
                        print("Form Submitted: \(viewModel.studentProfile)")
                    }
                }
            }
            .navigationTitle("Registration Form")
        }
    }
}

#Preview {
    StudentRegistrationView()
}
