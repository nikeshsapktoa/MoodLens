//
//  MoodLog.swift
//  MoodLens
//
//  Created by Nikesh Sapkota on 5/12/25.
//

import Foundation

struct MoodLog: Codable, Identifiable {
    let id = UUID()
    let mood: String
    let date: Date
    
    // Ensure that this struct is capable of being initialized properly.
    init(mood: String, date: Date) {
        self.mood = mood
        self.date = date
    }
}
