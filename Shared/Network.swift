//
//  Network.swift
//  FCFinderV2App
//
//  Created by Brad Leege on 7/27/20.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()
    
  private(set) lazy var apollo = ApolloClient(url: URL(string: "https://fcfinderv2.herokuapp.com/graphql")!)
}
