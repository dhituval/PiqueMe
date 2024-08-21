//
//  VirtualClosetView.swift
//  PiqueMe
//
//  Created by Diya Hituvalli on 8/21/24.
//
import SwiftUI

struct VirtualClosetView: View {
    @ObservedObject var viewModel: PhotoPickerViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Virtual Closet")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.pink)

            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.virtualCloset) { item in
                        VStack(alignment: .leading, spacing: 10) {
                            if let image = item.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(15)
                                    .shadow(radius: 10)
                            }

                            Text("Occasion: \(item.occasion)")
                                .font(.headline)
                                .foregroundColor(.pink)

                            Text("Type of clothing: \(item.clothingType)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                }
            }

            NavigationLink(destination: DressMeView(viewModel: viewModel)) {
                Text("Dress Me")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding()

            Spacer()
        }
        .padding()
        .background(Color(hex: "#FFC0CB")) // Light pink background color
        .cornerRadius(20)
        .shadow(radius: 10)
        .navigationTitle("Virtual Closet")
    }
}

#Preview {
    VirtualClosetView(viewModel: PhotoPickerViewModel())
}
