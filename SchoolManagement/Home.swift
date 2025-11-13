//
//  Home.swift
//  SchoolManagement
//
//  Created by Sajed Shaikh on 05/11/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "house")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text("Home")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("This is the home screen.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
