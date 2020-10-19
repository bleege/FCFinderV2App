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

class DataManager: DataManagerProtocol {

    func loadAllCountries() -> AnyPublisher<[Country], Error> {
        
        let futureAsyncPublisher = Future<[Country], Error> { promise in

            Network.shared.apollo.fetch(query: GetCountriesQuery()) { result in
                switch result {
                case .success(let graphQLResult):
                    print("successful load of data")
                    if let countriesArray = graphQLResult.data?.getAllCountries {
                        let countries = countriesArray.compactMap { Country(countryId: $0.id, name: $0.name) }
                        promise(.success(countries))
                    }
                    if let errors = graphQLResult.errors, let error = errors.first {
                        print("Errors: \(errors)")
                        promise(.failure(error))
                    }
                case .failure(let error):
                    print("Failure! Error: \(error)")
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
        
        return futureAsyncPublisher
    }
    
    func getLeaguesByCountry(countryId: Int) -> AnyPublisher<[League], Error> {
        let futureAsyncPublisher = Future<[League], Error> { promise in

            Network.shared.apollo.fetch(query: GetLeaguesByCountryQuery(countryId: countryId)) { result in
                switch result {
                case .success(let graphQLResult):
                    if let leagueArray = graphQLResult.data?.getLeaguesByCountryId {
                        let leagues = leagueArray.compactMap { League(leagueId: $0.id, name: $0.name, division: $0.division, country: Country(countryId: $0.country.id, name: $0.country.name), confederation: $0.confederation) }
                        promise(.success(leagues))
                    }
                    if let errors = graphQLResult.errors, let error = errors.first {
                        print("Errors: \(errors)")
                        promise(.failure(error))
                    }
                case .failure(let error):
                    print("Failure!: Error: \(error)")
                    promise(.failure(error))
                }
            }


        }.eraseToAnyPublisher()
        
        return futureAsyncPublisher
    }
    
    func getYearsForLeague(leagueId: Int) -> AnyPublisher<[Int], Error> {
        
        let futureAsyncPublisher = Future<[Int], Error> { promise in

            Network.shared.apollo.fetch(query: GetYearsForLeagueQuery(leagueId: leagueId)) { result in
                switch result {
                case .success(let graphQLResult):
                    if let yearsArray = graphQLResult.data?.getYearsForLeague {
                        promise(.success(yearsArray))
                    }
                    if let errors = graphQLResult.errors, let error = errors.first {
                        print("Errors: \(errors)")
                        promise(.failure(error))
                    }
                case .failure(let error):
                    print("Failure!: Error: \(error)")
                    promise(.failure(error))
                }
            }
            
        }.eraseToAnyPublisher()
        
        return futureAsyncPublisher
    }
    
    func getClubsForLeagueAndYear(leagueId: Int, year: Int) -> AnyPublisher<[Club], Error> {
        
        let futureAsyncPublisher = Future<[Club], Error> { promise in
            Network.shared.apollo.fetch(query: GetClubsByLeagueAndYearQuery(leagueId: leagueId, year: year)) { result in
                switch result {
                case .success(let graphQLResult):
                    if let clubsArray = graphQLResult.data?.getClubsByLeagueAndYear {
                        let clubs = clubsArray.compactMap { Club(clubId: $0.id, name: $0.name, stadiumName: $0.stadiumName, latitude: $0.latitude, longitude: $0.longitude) }
                        promise(.success(clubs))
                    }
                    if let errors = graphQLResult.errors, let error = errors.first {
                        print("Errors: \(errors)")
                        promise(.failure(error))
                    }
                case .failure(let error):
                    print("Failure!: Error: \(error)")
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
        
        return futureAsyncPublisher
    }
}
