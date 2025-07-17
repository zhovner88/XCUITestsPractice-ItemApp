//
//  NewItemView.swift
//  ItemApp
//
//  Created by Karin Prater on 24/05/2025.
//
import SwiftUI

struct NewItemView: View {
    
    @ObservedObject var viewModel: ItemViewModel
    @State private var newItemName = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Item name", text: $newItemName)
                .padding()
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier(UIIdentifiers.AddNewItem.itemNameTextField)
            
            Button("Add Item") {
                if !newItemName.isEmpty {
                    viewModel.addItem(name: newItemName)
                    dismiss()
                }
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier(UIIdentifiers.AddNewItem.addButton)
            .disabled(newItemName.isEmpty)
        }
        .padding()
    }
}

#Preview {
    NewItemView(viewModel: .init())
}
