//
//  PhotosPickerView.swift
//  SchoolManagement
//
//  Created by Sajed Shaikh on 19/11/25.
//

import SwiftUI
import PhotosUI

struct PhotosPickerView: View {
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    var body: some View {
        VStack {
            PhotosPicker(selection: $avatarItem, matching: .images) {
                Label("Select Photo", systemImage: "photo.on.rectangle.angled")
            }

            avatarImage?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
        }
        .onChange(of: avatarItem) {
            Task {
                if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                    avatarImage = loaded
                } else {
                    print("Failed")
                }
            }
        }
    }
}

#Preview {
    PhotosPickerView()
}
