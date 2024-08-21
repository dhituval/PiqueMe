////
////  SwiftUIView.swift
////  PiqueMe
////
////  Created by Diya Hituvalli on 8/21/24.
////
//
//import SwiftUI
//import PhotosUI
//import UIKit
//
//@MainActor
//final class PhotoPickerViewModel: ObservableObject {
//    
//    @Published private(set) var selectedImage: UIImage? = nil
//    @Published var imageSelection: PhotosPickerItem? = nil {
//        didSet {
//            setImage(from: imageSelection)
//        }
//    }
//    
//    private func setImage(from selection: PhotosPickerItem?) {
//        guard let selection else { return }
//        
//        Task {
//            if let data = try? await selection.loadTransferable(type: Data.self) {
//                if let uiImage = UIImage(data: data) {
//                    selectedImage = uiImage
//                    return
//                }
//            }
//            do {
//                let data = try await selection.loadTransferable(type: Data.self)
//                guard let data, let uiImage = UIImage(data: data) else {
//                    throw URLError(.badServerResponse)
//                }
//                selectedImage = uiImage
//            } catch {
//                print(error)
//            }
//        }
//    }
//}
//
//
//struct SwiftUIView: View {
//    @StateObject private var viewModel = PhotoPickerViewModel()
//    
//    var body: some View {
//        VStack(spacing: 40) {
//            
//            if let image = viewModel.selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 200, height: 200)
//                    .cornerRadius(20)
//            }
//            PhotosPicker(selection: $viewModel.imageSelection) {
//                Text("Upload a photo")
//                    .foregroundColor(.red)
//            }
//        }
//    }
//}
//
//#Preview {
//    SwiftUIView()
//}
import SwiftUI
import PhotosUI
import UIKit

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    @Published var occasion: String = ""
    @Published var clothingType: String = ""
    
    @Published var virtualCloset: [ClothingItem] = []
    @Published var selectedOccasionForDressMe: String = ""
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            do {
                if let data = try? await selection.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    return
                }
                throw URLError(.badServerResponse)
            } catch {
                print(error)
            }
        }
    }
    
    func uploadToVirtualCloset() {
        guard let image = selectedImage else { return }
        
        let newItem = ClothingItem(
            image: image,
            occasion: occasion,
            clothingType: clothingType
        )
        
        virtualCloset.append(newItem)
        
        // Reset the form
        selectedImage = nil
        occasion = ""
        clothingType = ""
    }
    func getRandomItem(for occasion: String) -> ClothingItem? {
        let trimmedOccasion = occasion.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let filteredItems = virtualCloset.filter { $0.occasion.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == trimmedOccasion }
        return filteredItems.randomElement()
    }
}

struct ClothingItem: Identifiable {
    let id = UUID()
    let image: UIImage
    let occasion: String
    let clothingType: String
}

import SwiftUI
import PhotosUI
import UIKit

import SwiftUI
import PhotosUI
import UIKit

struct SwiftUIView: View {
    @StateObject private var viewModel = PhotoPickerViewModel()
    @State private var selectedOccasion: String = ""
    @State private var selectedClothingType: String = ""
    @State private var showSuccessMessage: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Display selected image if available
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding(.top, 20)
                }
                
                // Occasion dropdown with label
                VStack(alignment: .leading) {
                    Text("Select Occasion")
                        .font(.headline)
                        .foregroundColor(.pink)
                    
                    Picker("Select Occasion", selection: $selectedOccasion) {
                        Text("Class").tag("Class")
                        Text("Office").tag("Office")
                        Text("Workout").tag("Workout")
                        Text("Night Out").tag("Night Out")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                // Clothing type dropdown with label
                VStack(alignment: .leading) {
                    Text("Select Clothing Type")
                        .font(.headline)
                        .foregroundColor(.pink)
                    
                    Picker("Select Clothing Type", selection: $selectedClothingType) {
                        Text("Top").tag("Top")
                        Text("Bottom").tag("Bottom")
                        Text("Skirt").tag("Skirt")
                        Text("Dress").tag("Dress")
                        Text("Workout Top").tag("Workout Top")
                        Text("Leggings").tag("Leggings")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .center) // Center the dropdown
                
                // PhotosPicker for selecting a photo
                PhotosPicker(selection: $viewModel.imageSelection) {
                    HStack {
                        Image(systemName: "photo.fill")
                        Text("Upload a photo")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("UploadButtonColor"))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding()
                
                // Upload button
                Button(action: {
                    viewModel.occasion = selectedOccasion
                    viewModel.clothingType = selectedClothingType
                    viewModel.uploadToVirtualCloset()
                    showSuccessMessage = true
                }) {
                    Text("Upload")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
                
                // Success message
                if showSuccessMessage {
                    Text("Photo successfully uploaded!")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .padding()
                }
                
                // Navigation button to Virtual Closet
                NavigationLink(destination: VirtualClosetView(viewModel: viewModel)) {
                    Text("Go to Virtual Closet")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 20)
            }
            .padding()
            .background(Color("#FFC0CB")) // Light pink background color
            .cornerRadius(20)
            .shadow(radius: 10)
            .navigationTitle("Upload Photo")
        }
    }
}

#Preview {
    SwiftUIView()
}
