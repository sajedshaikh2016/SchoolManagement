//
//  AdminAuthViewModel.swift
//  SchoolManagement
//
//  Created by Assistant on 12/11/25.
//

import Foundation
import Combine

@MainActor
final class AdminAuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String? = nil

    // For demo purposes, use a hardcoded admin credential.
    // Replace with secure verification (e.g., server-side) in real apps.
    private let validUsername = "admin"
    private let validPassword = "admin123"

    func login() async {
        errorMessage = nil
        let u = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let p = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !u.isEmpty else { errorMessage = "Please enter admin username"; return }
        guard !p.isEmpty else { errorMessage = "Please enter password"; return }

        // Simulate async work
        try? await Task.sleep(nanoseconds: 200_000_000)

        if u == validUsername && p == validPassword {
            isAuthenticated = true
        } else {
            isAuthenticated = false
            errorMessage = "Invalid admin credentials"
        }
    }

    func logout() {
        isAuthenticated = false
        username = ""
        password = ""
        errorMessage = nil
    }
}
