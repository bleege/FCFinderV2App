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

}
