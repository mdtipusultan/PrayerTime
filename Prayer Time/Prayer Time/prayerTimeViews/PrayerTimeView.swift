//
//  PrayerTimeView.swift
//  Bank_app
//
//  Created by Tipu on 1/9/24.
//

import SwiftUI

struct PrayerTimeView: View {
    @StateObject private var prayerViewModel = PrayerTimesViewModel()
    @State private var currentDateTime: Date = Date()
    
    // Update current date and time every second
    private let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    let buttonTitles = ["Tasbeeh", "Duah", "Hadith", "Kiblah", "Ramadan", "Namaz"]
    let buttonImages = ["Tasbeeh", "Duah", "Hadith", "Kiblah", "Ramadan", "Namaz"]
    let columns = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Top Section
                    HStack(spacing: 5) {
                        HStack(spacing: 0) {
                            Image("sun")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 57, height: 57, alignment: .center)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(formattedTime(currentDateTime))
                                    .font(.system(size: 14))
                                Text(formattedDate(currentDateTime))
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Next Azan Comes After")
                                .font(.system(size: 14))
                            if let prayerTimes = prayerViewModel.prayerTimes {
                                Text(prayerTimes.Dhuhr) // Example for Dhuhr, update accordingly
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            } else {
                                Text("Loading...")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 5)
                    
                    CarouselView()
                        .padding(.top)
                    
                    HStack(spacing: 10) {
                        // Existing ZStack with Buttons
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 156, height: 334)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                            
                            LazyVGrid(columns: columns, spacing: 35) {
                                ForEach(0..<buttonTitles.count, id: \.self) { index in
                                    NavigationLink(destination: destinationView(for: buttonTitles[index])) {
                                        VStack(spacing: 5) {
                                            Image(buttonImages[index])
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 43, height: 42)
                                            
                                            Text(buttonTitles[index])
                                                .font(.system(size: 14))
                                                .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                            .padding(.horizontal, 10) // Adjust padding if needed
                        }
                        
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 165, height: 334)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                            
                            VStack(spacing: 10) {
                                Text("Prayer Times")
                                    .font(.headline)
                                    .foregroundColor(Color("PrimaryColor"))
                                
                                Image("prayer_logo")
                                
                                if let prayerTimes = prayerViewModel.prayerTimes {
                                    VStack(alignment: .leading, spacing: 10) {
                                        prayerTimeRow(name: "Fajr", time: prayerTimes.Fajr)
                                        //prayerTimeRow(name: "Sunrise", time: prayerTimes.Sunrise)
                                        prayerTimeRow(name: "Dhuhr", time: prayerTimes.Dhuhr)
                                        prayerTimeRow(name: "Asr", time: prayerTimes.Asr)
                                        prayerTimeRow(name: "Maghrib", time: prayerTimes.Maghrib)
                                        prayerTimeRow(name: "Isha", time: prayerTimes.Isha)
                                    }
                                } else {
                                    Text("Loading...")
                                }
                                
                                
                            }
                            .padding()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
        .navigationTitle("Ibadah")
        .onReceive(timer) { input in
            currentDateTime = input
        }
    }
    
    // Format the current time as a string
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, hh:mm a"
        return formatter.string(from: date)
    }
    
    // Format the current date as a string
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    // Helper function to return the correct view for each button
    @ViewBuilder
    func destinationView(for title: String) -> some View {
        switch title {
        case "Tasbeeh":
            TasbeehView()
        case "Duah":
            DuahView()
        case "Hadith":
            HadithView()
        case "Kiblah":
            KiblahView()
        case "Ramadan":
            RamadanView()
        case "Namaz":
            NamazView()
        default:
            EmptyView()
        }
    }
    
    // Helper function to create a row for each prayer time
    @ViewBuilder
    func prayerTimeRow(name: String, time: String) -> some View {
        let formattedTime = convertTo12HourFormat(time)
        let prayerTime = convertToTime(time)
        let isNearest = isNearestPrayerTime(prayerTime)
        
        HStack {
            Text("\(name):")
                .font(.system(size: 14))
                .foregroundColor(isNearest ? .white : .black)
                .fontWeight(isNearest ? .bold : .regular)
            
            Spacer()
            
            Text(formattedTime)
                .font(.system(size: 14))
                .foregroundColor(isNearest ? .white : .black)
                .fontWeight(isNearest ? .bold : .regular)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
        .background(isNearest ? Color("PrimaryColor") : Color.clear)
        .cornerRadius(5)
    }
    
    
    // Convert 24-hour time string to 12-hour format with AM/PM
    func convertTo12HourFormat(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        
        if let date = formatter.date(from: timeString) {
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        }
        
        return timeString // Fallback to original string if conversion fails
    }
    
    
    // Convert time string to Date
    func convertToTime(_ timeString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: timeString) ?? Date()
    }
    
    // Determine if the current time is nearest to this prayer time
    func isNearestPrayerTime(_ prayerTime: Date) -> Bool {
        let currentTime = Calendar.current.dateComponents([.hour, .minute], from: currentDateTime)
        let prayerTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: prayerTime)
        
        guard let currentHour = currentTime.hour, let currentMinute = currentTime.minute,
              let prayerHour = prayerTimeComponents.hour, let prayerMinute = prayerTimeComponents.minute else {
            return false
        }
        
        let currentTotalMinutes = currentHour * 60 + currentMinute
        let prayerTotalMinutes = prayerHour * 60 + prayerMinute
        
        // Compare the difference between current time and prayer time
        return abs(currentTotalMinutes - prayerTotalMinutes) < 30 // Example threshold of 30 minutes
    }
}

#Preview {
    PrayerTimeView()
}

struct DuahView: View {
    var body: some View {
        Text("Duah")
            .navigationTitle("Duah")
    }
}

struct HadithView: View {
    var body: some View {
        Text("Hadith")
            .navigationTitle("Hadith")
    }
}

struct KiblahView: View {
    var body: some View {
        Text("Kiblah")
            .navigationTitle("Kiblah")
    }
}

struct RamadanView: View {
    var body: some View {
        Text("Ramadan")
            .navigationTitle("Ramadan")
    }
}

struct NamazView: View {
    var body: some View {
        Text("Namaz")
            .navigationTitle("Namaz")
    }
}
