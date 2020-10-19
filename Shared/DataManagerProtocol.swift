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
    
}
