//
//  ContentView.swift
//  Shared
//
//  Created by Brad Leege on 7/7/20.
//

import SwiftUI
import MapKit
import Combine

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
            
    init() {
        self.init(viewModel: MainViewModel())
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            MapView(coordinateRegion: $viewModel.region, clubs: $viewModel.clubs)
            BottomSheetView(isOpen: $viewModel.bottomSheetShown, maxHeight: geometry.size.height * 0.5) {
                NavigationView {
                    Form {
                        Picker("Countries", selection: $viewModel.selectedCountryId) {
                            ForEach(viewModel.countries) { country in
                                Text(country.name).tag(country.countryId)
                            }
                        }
                        Picker("Leagues", selection: $viewModel.selectedLeagueId) {
                            ForEach(viewModel.countryLeagues) { league in
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

// MARK: - Preview
#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
