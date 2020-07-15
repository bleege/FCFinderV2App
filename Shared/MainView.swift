//
//  ContentView.swift
//  Shared
//
//  Created by Brad Leege on 7/7/20.
//

import SwiftUI
import MapKit

struct MainView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.07472, longitude: -89.38421), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5 ))
    @State private var bottomSheetShown = false
    
    var body: some View {

        GeometryReader { geometry in

        Map(coordinateRegion: $region)
            .navigationTitle("Some League")
            .navigationBarTitleDisplayMode(.inline)
        BottomSheetView(isOpen: $bottomSheetShown, maxHeight: 600) {
            Text("Bottomr Sheet Content!")
        }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
