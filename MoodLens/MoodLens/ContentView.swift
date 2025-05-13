//
//  ContentView.swift
//  MoodLens
//
//  Created by Nikesh Sapkota on 5/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MoodTrackerView()
                .tabItem {
                    Label("Tracker", systemImage: "face.smiling")
                }

            MoodHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }
    }
}

#Preview {
    ContentView()
}

