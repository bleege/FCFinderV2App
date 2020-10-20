//
//  DataManagerMock.swift
//  Tests iOS
//
//  Created by Brad Leege on 10/19/20.
//

import Foundation
import Combine
@testable import FCFinderV2App

class DataManagerMock: DataManagerProtocol {
    func loadAllCountries() -> AnyPublisher<[Country], Error> {
        return Future<[Country], Error> { promise in
            promise(.success([Country(countryId: 1, name: "United States"), Country(countryId: 2, name: "Germany")]))
        }.eraseToAnyPublisher()
    }
    
    func getLeaguesByCountry(countryId: Int) -> AnyPublisher<[League], Error> {
        return Future<[League], Error> { promise in
            promise(.success([League(leagueId: 1, name: "MLS", division: 1, country: Country(countryId: 1, name: "United States"), confederation: "CONCACAF")]))
        }.eraseToAnyPublisher()
    }
    
    func getYearsForLeague(leagueId: Int) -> AnyPublisher<[Int], Error> {
        return Future<[Int], Error> { promise in
            promise(.success([2020, 2021]))
        }.eraseToAnyPublisher()
    }
    
    func getClubsForLeagueAndYear(leagueId: Int, year: Int) -> AnyPublisher<[Club], Error> {
        return Future<[Club], Error> { promise in
            promise(.success([Club(clubId: 1, name: "Seattle Sounders", stadiumName: "CenturyLink Field", latitude: 47.59506, longitude: -122.33163)]))
        }.eraseToAnyPublisher()
    }
        
}
