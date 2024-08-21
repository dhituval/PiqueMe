//
//  DressMeView.swift
//  PiqueMe
//
//  Created by Diya Hituvalli on 8/21/24.
//

import SwiftUI

struct DressMeView: View {
    @ObservedObject var viewModel: PhotoPickerViewModel
    @State private var selectedOccasion: String = ""
    @State private var outfit: ClothingItem? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Dress Me")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.pink)
            
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
            .frame(maxWidth: .infinity, alignment: .center) // Center the dropdown
            
            // Button to find outfit
            Button(action: {
                if let selectedOutfit = viewModel.getRandomItem(for: selectedOccasion) {
                    outfit = selectedOutfit
                } else {
                    outfit = nil
                }
            }) {
                Text("Find Outfit")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding()
            
            // Display selected outfit if available
            if let outfit = outfit {
                VStack(alignment: .leading) {
                    Image(uiImage: outfit.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    
                    Text("Occasion: \(outfit.occasion)")
                        .font(.headline)
                        .foregroundColor(.pink)
                    
                    Text("Type of clothing: \(outfit.clothingType)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
            } else if !selectedOccasion.isEmpty {
                Text("No item found for the selected occasion")
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .background(Color(hex: "#FFC0CB")) // Light pink background color
        .cornerRadius(20)
        .shadow(radius: 10)
        .navigationTitle("Dress Me")
    }
}


#Preview {
    DressMeView(viewModel: PhotoPickerViewModel())
}
