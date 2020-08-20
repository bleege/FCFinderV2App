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
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.07472, longitude: -89.38421), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5 ))
    @State private var bottomSheetShown = false
        
    init() {
        self.init(viewModel: ViewModel())
    }
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            Map(coordinateRegion: $region)
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
        @Published var selectedCountryId: Int = -1 {
            didSet {
                getLeaguesByCountry(countryId: selectedCountryId)
            }
        }
        @Published var selectedLeagueId: Int = -1

        
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
