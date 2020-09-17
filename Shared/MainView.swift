//
//  ContentView.swift
//  Shared
//
//  Created by Brad Leege on 7/7/20.
//

import SwiftUI
import MapKit

struct MainView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var bottomSheetShown = false
        
    init() {
        self.init(viewModel: ViewModel())
    }
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        GeometryReader { geometry in
//            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.clubs) { (club) -> MapPin in
//                return MapPin(coordinate: CLLocationCoordinate2DMake(club.latitude, club.longitude))
//            }
            MapView(coordinateRegion: $viewModel.region, annotations: [])
            BottomSheetView(isOpen: $bottomSheetShown, maxHeight: geometry.size.height * 0.5) {
                NavigationView {
                    Form {
                        Picker("Countries", selection: $viewModel.selectedCountryId) {
                            ForEach(viewModel.countries) { country in
                                Text(country.name).tag(country.countryId)
                            }
                        }
                        Picker("Leagues", selection: $viewModel.selectedLeagueId) {
                            ForEach(viewModel.countryLeages) { league in
                                Text(league.name).tag(league.leagueId)
                            }
                        }
                        Picker("Years", selection: $viewModel.selectedLeagueYear) {
                            ForEach(viewModel.leagueYears, id: \.self) { year in
                                Text(year.description).tag(year)
                            }
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

extension MainView {
    
    class ViewModel: ObservableObject {
        @Published private(set) var countries: [Country] = []
        @Published private(set) var countryLeages: [League] = []
        @Published private(set) var leagueYears: [Int] = []
        @Published private(set) var clubs: [Club] = []
        @Published var selectedCountryId: Int = -1 {
            didSet {
                getLeaguesByCountry(countryId: selectedCountryId)
            }
        }
        @Published var selectedLeagueId: Int = -1 {
            didSet {
                getYearsForLeague(leagueId: selectedLeagueId)
            }
        }
        @Published var selectedLeagueYear: Int = -1 {
            didSet {
                getClubsForLeagueAndYear(leagueId: selectedLeagueId, year: selectedLeagueYear)
            }
        }
        
        @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.07472, longitude: -89.38421), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5 ))
        
        init() {
            loadAllCountries()
        }

        func loadAllCountries() {
            print("loadAllCountries() called...")
            Network.shared.apollo.fetch(query: GetCountriesQuery()) { result in
              switch result {
              case .success(let graphQLResult):
                print("successful load of data")
                self.countries.removeAll()
                if let countriesArray = graphQLResult.data?.getAllCountries {
                    self.countries.append(contentsOf: countriesArray.compactMap { Country(countryId: $0.id, name: $0.name) })
                }
                if let errors = graphQLResult.errors {
                    print("Errors: \(errors)")
                }
              case .failure(let error):
                print("Failure! Error: \(error)")
              }
            }

        }
        
        func getLeaguesByCountry(countryId: Int) {
            print("getLeaguesByCountry with countryId = \(countryId)")
            Network.shared.apollo.fetch(query: GetLeaguesByCountryQuery(countryId: countryId)) { result in
                switch result {
                case .success(let graphQLResult):
                    self.countryLeages.removeAll()
                    if let leagueArray = graphQLResult.data?.getLeaguesByCountryId {
                        self.countryLeages.append(contentsOf: leagueArray.compactMap { League(leagueId: $0.id, name: $0.name, division: $0.division, country: Country(countryId: $0.country.id, name: $0.country.name), confederation: $0.confederation) })
                    }
                    if let errors = graphQLResult.errors {
                        print("Errors: \(errors)")
                    }
                case .failure(let error):
                    print("Failure!: Error: \(error)")
                }
            }
        }
        
        func getYearsForLeague(leagueId: Int) {
            print("getYearsForLeague() with leagueId = \(leagueId)")
            Network.shared.apollo.fetch(query: GetYearsForLeagueQuery(leagueId: leagueId)) { result in
                switch result {
                case .success(let graphQLResult):
                    self.leagueYears.removeAll()
                    if let yearsArray = graphQLResult.data?.getYearsForLeague {
                        self.leagueYears.append(contentsOf: yearsArray)
                    }
                    if let errors = graphQLResult.errors {
                        print("Errors: \(errors)")
                    }
                case .failure(let error):
                    print("Failure!: Error: \(error)")
                }
            }
            
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
    
}


// MARK: - Preview
#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
