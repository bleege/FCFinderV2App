//
//  MainViewModel.swift
//  FCFinderV2App
//
//  Created by Brad Leege on 10/18/20.
//

import Foundation
import Combine
import MapKit

class MainViewModel: ObservableObject {
    // MARK: - DataManager
    private let dataManager: DataManagerProtocol
    
    // MARK: - Published Data
    @Published var countries: [Country] = []
    @Published var countryLeagues: [League] = []
    @Published var leagueYears: [Int] = []
    @Published var clubs: [Club] = []
    @Published var selectedCountryId: Int = -1
    @Published var selectedLeagueId: Int = -1
    @Published var selectedLeagueYear: Int = -1
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.07472, longitude: -89.38421), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5 ))
    @Published var bottomSheetShown = false
    
    private var allCountriesCancellable: AnyCancellable?
    private var getLeaguesCancellable: AnyCancellable?
    private var getYearsCancellable: AnyCancellable?
    private var countryCancellable: AnyCancellable?
    private var leagueCancellable: AnyCancellable?
    private var yearCancellable: AnyCancellable?
    
    init(_ dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
        loadAllCountries()
        
        // Listen for data changes from UI
        // https://www.appsdissected.com/save-sink-assign-subscriber-anycancellable/
        countryCancellable = self.$selectedCountryId.sink(receiveValue: { [weak self] value in
            print("selectedCountryId received = \(value)")
            if (value >= 0) {
                self?.getLeaguesByCountry(countryId: value)
                self?.selectedLeagueId = -1
                self?.selectedLeagueYear = -1
            }
        })
        leagueCancellable = self.$selectedLeagueId.sink(receiveValue: { [weak self] value in
            print("selectedLeagueId received = \(value)")
            if (value >= 0) {
                self?.getYearsForLeague(leagueId: value)
                self?.selectedLeagueYear = -1
            }
        })
        yearCancellable = self.$selectedLeagueYear.sink(receiveValue: { [weak self] value in
            print("selectedLeagueYear received = \(value)")
            if let leagueId = self?.selectedLeagueId, value >= 0 {
                self?.getClubsForLeagueAndYear(leagueId: leagueId, year: value)
                self?.bottomSheetShown = false
            }
        })
        
    }
    
    func loadAllCountries() {
        print("loadAllCountries() called...")
        allCountriesCancellable = dataManager.loadAllCountries().sink(receiveCompletion: { message in
            // No Op
        }, receiveValue: { countries in
            self.countries.removeAll()
            self.countries.append(contentsOf: countries)
        })
    }
    
    func getLeaguesByCountry(countryId: Int) {
        print("getLeaguesByCountry with countryId = \(countryId)")
        getLeaguesCancellable = dataManager.getLeaguesByCountry(countryId: countryId).sink(receiveCompletion: { message in
            // No Op
        }, receiveValue: { leagues in
            self.countryLeagues.removeAll()
            self.countryLeagues.append(contentsOf: leagues)
        })
    }
    
    func getYearsForLeague(leagueId: Int) {
        print("getYearsForLeague() with leagueId = \(leagueId)")
        getYearsCancellable = dataManager.getYearsForLeague(leagueId: leagueId).sink(receiveCompletion: { message in
            // No Op
        }, receiveValue: { years in
            self.leagueYears.removeAll()
            self.leagueYears.append(contentsOf: years)
        })
    }
    
    func getClubsForLeagueAndYear(leagueId: Int, year: Int) {
        print("getClubsForLeagueAndYear() called with leagueId = \(leagueId) and year = \(year)")
        Network.shared.apollo.fetch(query: GetClubsByLeagueAndYearQuery(leagueId: leagueId, year: year)) { result in
            switch result {
            case .success(let graphQLResult):
                self.clubs.removeAll()
                if let clubsArray = graphQLResult.data?.getClubsByLeagueAndYear {
                    print("clubsArray = \(clubsArray)")
                    self.clubs.append(contentsOf: clubsArray.compactMap { Club(clubId: $0.id, name: $0.name, stadiumName: $0.stadiumName, latitude: $0.latitude, longitude: $0.longitude) })
                    self.region = self.generateMapRegion()
                }
                if let errors = graphQLResult.errors {
                    print("Errors: \(errors)")
                }
            case .failure(let error):
                print("Failure!: Error: \(error)")
            }
        }
    }
    
    private func generateMapRegion() -> MKCoordinateRegion {
        if clubs.count == 0 {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.07472, longitude: -89.38421), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5 ))
        }
        
        var maxLat: Double = -200.0
        var maxLong: Double = -200.0
        var minLat: Double = Double.infinity
        var minLong: Double = Double.infinity
        
        clubs.forEach { coordinate in
            if (coordinate.latitude < minLat) {
                minLat = coordinate.latitude;
            }
            
            if (coordinate.longitude < minLong) {
                minLong = coordinate.longitude;
            }
            
            if (coordinate.latitude > maxLat) {
                maxLat = coordinate.latitude;
            }
            
            if (coordinate.longitude > maxLong) {
                maxLong = coordinate.longitude;
            }
        }
        let center = CLLocationCoordinate2DMake((maxLat + minLat) * 0.5, (maxLong + minLong) * 0.5)
        return MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.25, longitudeDelta: (maxLong - minLong) * 1.25))
    }
    
}
