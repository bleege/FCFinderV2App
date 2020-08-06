//
//  Country.swift
//  FCFinderV2App
//
//  Created by Brad Leege on 8/2/20.
//

import Foundation

struct Country: Identifiable, Hashable {
    let id: UUID
    let countryId: Int
    let name: String
    
    init(countryId: Int, name: String) {
        self.id = UUID()
        self.countryId = countryId
        self.name = name
    }
    
}
