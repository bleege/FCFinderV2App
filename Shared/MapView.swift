//
//  MapView.swift
//  FCFinderV2App
//
//  From: https://www.hackingwithswift.com/books/ios-swiftui/advanced-mkmapview-with-swiftui
//
//  Created by Brad Leege on 9/16/20.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var coordinateRegion: MKCoordinateRegion
    var annotations: [MKPointAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        print("updateMapView....")
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
        view.region = coordinateRegion
    }

//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: MapView
//
//        init(_ parent: MapView) {
//            self.parent = parent
//        }
//
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            parent.coordinateRegion = mapView.region
//        }
//    }
}
