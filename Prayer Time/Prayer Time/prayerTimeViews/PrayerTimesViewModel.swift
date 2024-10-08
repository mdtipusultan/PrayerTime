//
//  PrayerTimesViewModel.swift
//  Bank_app
//
//  Created by Tipu on 3/9/24.
//



import Foundation
import Combine
import CoreLocation

class PrayerTimesViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var prayerTimes: Timings?
    @Published var errorMessage: String?
    
    private let locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func fetchPrayerTimes(for date: String, latitude: Double, longitude: Double) {
        let urlString = "https://api.aladhan.com/v1/timings/\(date)?latitude=\(latitude)&longitude=\(longitude)"
        
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PrayerTimesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = "Failed to load prayer times: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                self.prayerTimes = response.data.timings
            })
            .store(in: &cancellables)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let date = DateFormatter()
        date.dateFormat = "dd-MM-yyyy"
        fetchPrayerTimes(for: date.string(from: Date()), latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.errorMessage = "Failed to get location: \(error.localizedDescription)"
    }
}
