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
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.07472, longitude: -89.38421), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5 ))
    @State private var bottomSheetShown = false
    @State private var selectedFlavor = Flavor.chocolate
    
    var body: some View {
        
        GeometryReader { geometry in
            Map(coordinateRegion: $region)
            BottomSheetView(isOpen: $bottomSheetShown, maxHeight: geometry.size.height * 0.5) {
                Text("Selected League Name Goes Here")
                NavigationView {
                    Form {
                        Picker("Flavor 1", selection: $selectedFlavor) {
                            ForEach(Flavor.allCases) { flavor in
                                Text(flavor.rawValue.capitalized)
                            }
                        }.onAppear {
                            Network.shared.apollo.fetch(query: GetCountriesQuery()) { result in
                              switch result {
                              case .success(let graphQLResult):
                                print("Success! Result: \(graphQLResult)")
                              case .failure(let error):
                                print("Failure! Error: \(error)")
                              }
                            }
                        }
                        Picker("Flavor 2", selection: $selectedFlavor) {
                            ForEach(Flavor.allCases) { flavor in
                                Text(flavor.rawValue.capitalized)
                            }
                        }
                        Picker("Flavor 3", selection: $selectedFlavor) {
                            ForEach(Flavor.allCases) { flavor in
                                Text(flavor.rawValue.capitalized)
                            }
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
