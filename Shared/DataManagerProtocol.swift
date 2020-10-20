//
//  DataManagerProtocol.swift
//  FCFinderV2App
//
//  Created by Brad Leege on 10/18/20.
//

import Foundation
import Combine

protocol DataManagerProtocol {
    func loadAllCountries() -> AnyPublisher<[Country], Error>
    func getLeaguesByCountry(countryId: Int) -> AnyPublisher<[League], Error>
    func getYearsForLeague(leagueId: Int) -> AnyPublisher<[Int], Error>
    func getClubsForLeagueAndYear(leagueId: Int, year: Int) -> AnyPublisher<[Club], Error>
}
