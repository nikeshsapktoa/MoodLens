import SwiftUI
import Charts

struct MoodHistoryView: View {
    @State private var moodLogs: [MoodLog] = []
    @State private var moodCounts: [DailyMoodCount] = []

    var body: some View {
        VStack(alignment: .leading) {
            if !moodCounts.isEmpty {
                Text("Mood Activity (Last 7 Days)")
                    .font(.headline)
                    .padding(.top)

                Chart(moodCounts) { mood in
                    BarMark(
                        x: .value("Date", formattedShortDate(mood.date)),
                        y: .value("Count", mood.count)
                    )
                    .foregroundStyle(Color.blue)
                }
                .frame(height: 200)
                .padding()
            }

            List(moodLogs) { log in
                HStack {
                    Text(log.mood)
                    Spacer()
                    Text(formattedDate(log.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Mood History")
        .onAppear(perform: loadMoodLogs)
    }

    func loadMoodLogs() {
        if let data = UserDefaults.standard.data(forKey: "moodLogs"),
           let decoded = try? JSONDecoder().decode([MoodLog].self, from: data) {
            moodLogs = decoded.reversed()
            moodCounts = countMoodsPerDay(logs: decoded)
            print("✅ moodCounts: \(moodCounts)")
        }
    }

    func countMoodsPerDay(logs: [MoodLog]) -> [DailyMoodCount] {
        let calendar = Calendar.current
        let last7Days = (0..<7).compactMap { calendar.date(byAdding: .day, value: -$0, to: Date()) }

        return last7Days.reversed().map { day in
            let count = logs.filter {
                calendar.isDate($0.date, inSameDayAs: day)
            }.count
            return DailyMoodCount(date: day, count: count)
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func formattedShortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

struct DailyMoodCount: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

