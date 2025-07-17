//
//  ItemAppApp.swift
//  ItemApp
//
//  Created by Karin Prater on 12/05/2025.
//

import SwiftUI

@main
struct ItemAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ItemViewModel())
        }
    }
}
