//
//  League.swift
//  FCFinderV2App
//
//  Created by Brad Leege on 8/19/20.
//

import Foundation

struct League: Hashable, Identifiable {
    let id: UUID
    let leagueId: Int
    let name: String
    let division: Int
    let country: Country
    let confederation: String
    
    init(leagueId: Int, name: String, division: Int, country: Country, confederation: String) {
        self.id = UUID()
        self.leagueId = leagueId
        self.name = name
        self.division = division
        self.country = country
        self.confederation = confederation
    }
    
}
