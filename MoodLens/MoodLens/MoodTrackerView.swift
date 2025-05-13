import SwiftUI

struct MoodTrackerView: View {
    @State private var selectedMood: String = "Happy"
    @State private var moodLogs: [MoodRecord] = []
    @State private var showAlert: Bool = false
    @State private var emojis: [String] = []
    @State private var emojiPositions: [CGPoint] = []
    @State private var emojiSizes: [CGFloat] = []
    @State private var emojiAnimations = [Bool]()
    
    let moods = ["Happy", "Sad", "Neutral", "Stressed", "Excited", "Angry"]
    let emojiDict: [String: String] = [
        "Happy": "🙂",
        "Sad": "😢",
        "Neutral": "😐",
        "Stressed": "😣",
        "Excited": "🤩",
        "Angry": "😡"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AnimatedBackgroundView()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Log Your Mood")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                    
                    // Mood Picker
                    Picker("Select Mood", selection: $selectedMood) {
                        ForEach(moods, id: \.self) { mood in
                            Text(mood).foregroundColor(.white)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    
                    // Log Mood Button
                    Button(action: {
                        logMood()
                        animateEmojis()
                    }) {
                        Text("Log Mood")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    // Mood History
                    Text("Your Mood History")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top)

                    // Custom List
                    List {
                        ForEach(moodLogs) { log in
                            HStack {
                                Text(log.mood)
                                    .foregroundColor(.white)
                                Spacer()
                                Text(formattedDate(log.date))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(10)
                            .transition(.slide)
                        }
                    }
                    .onAppear(perform: loadMoodLogs)
                    
                    Spacer()
                }
                
                // Flying Emojis
                ForEach(0..<emojis.count, id: \.self) { index in
                    Text(emojis[index])
                        .font(.system(size: emojiSizes[index]))
                        .position(emojiPositions[index])
                        .scaleEffect(emojiSizes[index] / 50)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                emojiSizes[index] = 250
                                emojiPositions[index] = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                            }
                            withAnimation(.easeInOut(duration: 2).delay(1)) {
                                emojiPositions[index] = CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height / 2)
                                emojiSizes[index] = 50
                            }
                        }
                }
            }
            .navigationTitle("Mood Tracker")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Mood Logged"),
                    message: Text("Your mood has been successfully logged."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Log Mood Function
    func logMood() {
        let newMoodLog = MoodRecord(mood: selectedMood, date: Date())
        moodLogs.insert(newMoodLog, at: 0)
        
        // Save the logs to UserDefaults
        if let data = try? JSONEncoder().encode(moodLogs) {
            UserDefaults.standard.set(data, forKey: "moodLogs")
        }
        
        showAlert = true
    }
    
    // Load Mood Logs
    func loadMoodLogs() {
        if let data = UserDefaults.standard.data(forKey: "moodLogs"),
           let decodedLogs = try? JSONDecoder().decode([MoodRecord].self, from: data) {
            moodLogs = decodedLogs.reversed()
        }
    }
    
    // Date Formatter
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Animate Emojis for Mood
    func animateEmojis() {
        emojis = []
        emojiPositions = []
        emojiSizes = []
        emojiAnimations = []
        
        let emoji = emojiDict[selectedMood] ?? "🙂"
        let numberOfEmojis = 5 // Number of emojis to animate
        for _ in 0..<numberOfEmojis {
            emojis.append(emoji)
            emojiPositions.append(CGPoint(x: 0, y: UIScreen.main.bounds.height / 2))
            emojiSizes.append(50)
            emojiAnimations.append(true)
        }
    }
}

struct MoodRecord: Identifiable, Codable, Equatable {
    var id = UUID()
    var mood: String
    var date: Date
    
    static func ==(lhs: MoodRecord, rhs: MoodRecord) -> Bool {
        return lhs.id == rhs.id && lhs.mood == rhs.mood && lhs.date == rhs.date
    }
}

struct AnimatedBackgroundView: View {
    @State private var gradientStart = 0.0
    @State private var gradientEnd = 1.0
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .rotationEffect(Angle(degrees: gradientStart))
            .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false), value: gradientStart)
            .onAppear {
                gradientStart = 180
            }
            .edgesIgnoringSafeArea(.all)
    }
}

