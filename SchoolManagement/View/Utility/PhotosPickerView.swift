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
        VStack {
            HStack {
                Text(title)
                Spacer()
                if let data = imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                }
            }

            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label(
                    "Select or update image",
                    systemImage: "photo.on.rectangle.angled"
                )
            }
            // Use .onChange to trigger the view model loading logic when the selection changes
            .onChange(of: selectedItem) { oldValue, newItem in
                onItemChange(newItem)
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    PhotosPickerView(
        title: "Dummy Title",
        imageData: nil,
        selectedItem: .constant(nil)
    ) { selectedItem in
        // Handle item change
    }
}
