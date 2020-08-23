//
//  Club.swift
//  FCFinderV2App
//
//  Created by Brad Leege on 8/22/20.
//

import Foundation

struct Club: Identifiable, Hashable {
    let id: UUID
    let clubId: Int
    let name: String
    let stadiumName: String
    let latitude: Double
    let longitude: Double
    
    init(clubId: Int, name: String, stadiumName: String, latitude: Double, longitude: Double) {
        self.id = UUID()
        self.clubId = clubId
        self.name = name
        self.stadiumName = stadiumName
        self.latitude = latitude
        self.longitude = longitude
    }

}
