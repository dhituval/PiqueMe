////
////  SwiftUIView.swift
////  PiqueMe
////
////  Created by Diya Hituvalli on 8/21/24.
////

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
    let image: UIImage?
    let occasion: String
    let clothingType: String
}

struct SwiftUIView: View {
    @StateObject private var viewModel = PhotoPickerViewModel()
    @State private var selectedOccasion: String = ""
    @State private var selectedClothingType: String = ""
    @State private var showSuccessMessage: Bool = false

    var body: some View {
        ZStack {
            // Full-screen pink background
            Color(hex: "#FFC0CB")
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Title
                Text("Update Me")
                    .font(.custom("Didot-Bold", size: 32)) // Didot font
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(hex: "#FB607F")) // Updated pink color
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding(.top, 40)
                
                // Display selected image if available
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150) // Reduced size
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .padding(.bottom, 20)
                        .transition(.opacity) // Smooth transition
                } else {
                    // Placeholder for image space
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 150, height: 150)
                }
                
                // Occasion dropdown with label
                VStack(alignment: .center) {
                    Text("Select Occasion")
                        .font(.custom("Didot-Medium", size: 18)) // Didot font
                        .foregroundColor(Color(hex: "#FB607F")) // Updated pink color
                    
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
                VStack(alignment: .center) {
                    Text("Select Clothing Type")
                        .font(.custom("Didot-Medium", size: 18)) // Didot font
                        .foregroundColor(Color(hex: "#FB607F")) // Updated pink color
                    
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
                
                // PhotosPicker for selecting a photo
                PhotosPicker(selection: $viewModel.imageSelection) {
                    HStack {
                        Image(systemName: "photo.fill")
                        Text("Upload a photo")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(hex: "#FB607F")) // Updated pink color
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
                        .font(.custom("Didot-Medium", size: 18)) // Didot font
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: "#FB607F")) // Updated pink color
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
                
                // Success message
                if showSuccessMessage {
                    Text("Photo successfully uploaded!")
                        .font(.custom("Didot-Regular", size: 16)) // Didot font
                        .foregroundColor(.green)
                        .padding()
                        .transition(.opacity) // Smooth transition
                }
                
                // Navigation button to Virtual Closet
                NavigationLink(destination: VirtualClosetView(viewModel: viewModel)) {
                    Text("Go to Virtual Closet")
                        .font(.custom("Didot-Medium", size: 18)) // Didot font
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: "#FB607F")) // Updated pink color
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 20) // Adjust padding to move the button up
            }
            .padding()
        }
        .navigationTitle("") // No title here to avoid conflict with custom title
    }
}

#Preview {
    SwiftUIView()
}
