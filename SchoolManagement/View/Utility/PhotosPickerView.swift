//
//  PhotosPickerView.swift
//  SchoolManagement
//
//  Created by Sajed Shaikh on 19/11/25.
//

import PhotosUI
import SwiftUI

struct PhotosPickerView: View {
    let title: String
    let imageData: Data?
    @Binding var selectedItem: PhotosPickerItem?
    let onItemChange: (PhotosPickerItem?) -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(alignment: .center, spacing: 16) {
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let data = imageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            ZStack {
                                Circle()
                                    .fill(.thinMaterial)
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.secondary)
                                    .padding(10)
                            }
                        }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .strokeBorder(.quaternary, lineWidth: 1)
                    )

                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Image(systemName: "pencil.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 22))
                            .background(Circle().fill(.background))
                    }
                    .buttonStyle(.plain)
                    .offset(x: 2, y: 2)
                    .accessibilityLabel("Edit photo")
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    if let data = imageData, UIImage(data: data) != nil {
                        Text("Tap the pencil to change the image.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Add a clear, front-facing photo.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }

            HStack(spacing: 12) {
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Label("", systemImage: "photo.on.rectangle.angled")
                        .font(.body)
                }
                .buttonStyle(.borderedProminent)

                if imageData != nil {
                    Button(role: .destructive) {
                        // Clear the selection and notify caller to clear data
                        selectedItem = nil
                        onItemChange(nil)
                    } label: {
                        Label("", systemImage: "trash")
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.quaternary, lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
        .onChange(of: selectedItem) { oldValue, newItem in
            onItemChange(newItem)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PhotosPickerView(
            title: "Profile Photo",
            imageData: nil,
            selectedItem: .constant(nil)
        ) { _ in }

        PhotosPickerView(
            title: "Guardian Photo",
            imageData: UIImage(systemName: "person.circle")?.pngData(),
            selectedItem: .constant(nil)
        ) { _ in }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
