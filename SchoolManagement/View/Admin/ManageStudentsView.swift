//
//  ManageStudentsView.swift
//  SchoolManagement
//
//  Created by Sajed Shaikh on 19/11/25.
//

import SwiftUI

struct ManageStudentsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text("Manage Students")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("This is the home screen.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Manage Students")
    }
}

#Preview {
    ManageStudentsView()
}
