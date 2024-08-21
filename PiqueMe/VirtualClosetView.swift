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
        List(viewModel.virtualCloset) { item in
            VStack(alignment: .leading) {
                Image(uiImage: item.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                
                Text("Occasion: \(item.occasion)")
                    .font(.headline)
                    .padding(.top, 5)
                
                Text("Type of clothing: \(item.clothingType)")
                    .font(.subheadline)
                    .padding(.bottom, 5)
            }
            .padding()
        }
        .navigationTitle("Virtual Closet")
    }
}

#Preview {
    VirtualClosetView(viewModel: PhotoPickerViewModel())
}
