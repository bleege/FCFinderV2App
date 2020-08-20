//
//  ContentView.swift
//  Shared
//
//  Created by Brad Leege on 7/7/20.
//

import SwiftUI
import MapKit

enum Flavor: String, CaseIterable, Identifiable {
    case chocolate
    case vanilla
    case strawberry

    var id: String { self.rawValue }
}

struct MainView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.07472, longitude: -89.38421), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5 ))
    @State private var bottomSheetShown = false
    @State private var selectedFlavor = Flavor.strawberry
        
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
                Text("Selected Flavor = \(selectedFlavor.rawValue)")
                NavigationView {
                    Form {
                        Picker("Countries", selection: $viewModel.selectedCountryId) {
                            ForEach(viewModel.countries) { country in
                                Text(country.name).tag(country.countryId)
                            }
                        }
                        Picker("Flavor 2", selection: $selectedFlavor) {
                            ForEach(Flavor.allCases) { flavor in
                                Text(flavor.rawValue.capitalized).tag(flavor)
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
        @Published var selectedCountryId: Int = -1 {
            didSet {
                getLeaguesByCountry(countryId: selectedCountryId)
            }
        }
        
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
                    print("Success loaded leagues: \(graphQLResult.data?.getLeaguesByCountryId)")
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
