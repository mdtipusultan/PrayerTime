//
//  PrayerModel.swift
//  Prayer Time
//
//  Created by Tipu on 4/9/24.
//

import Foundation

struct PrayerTimesResponse: Codable {
    let code: Int
    let status: String
    let data: PrayerData
}

struct PrayerData: Codable {
    let timings: Timings
    let date: DateInfo
}

struct Timings: Codable {
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Sunset: String
    let Maghrib: String
    let Isha: String
    let Imsak: String
    let Midnight: String
}

struct DateInfo: Codable {
    let readable: String
    let timestamp: String
    let gregorian: Gregorian
    let hijri: Hijri
}

struct Gregorian: Codable {
    let date: String
    let format: String
    let day: String
    let weekday: Weekday
    let month: Month
    let year: String
}

struct Hijri: Codable {
    let date: String
    let format: String
    let day: String
    let weekday: Weekday
    let month: Month
    let year: String
}

struct Weekday: Codable {
    let en: String
    let ar: String?
}

struct Month: Codable {
    let number: Int
    let en: String
    let ar: String?
}
