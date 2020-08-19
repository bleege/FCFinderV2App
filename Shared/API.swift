// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetCountriesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetCountries {
      getAllCountries {
        __typename
        id
        name
      }
    }
    """

  public let operationName: String = "GetCountries"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getAllCountries", type: .nonNull(.list(.nonNull(.object(GetAllCountry.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getAllCountries: [GetAllCountry]) {
      self.init(unsafeResultMap: ["__typename": "Query", "getAllCountries": getAllCountries.map { (value: GetAllCountry) -> ResultMap in value.resultMap }])
    }

    public var getAllCountries: [GetAllCountry] {
      get {
        return (resultMap["getAllCountries"] as! [ResultMap]).map { (value: ResultMap) -> GetAllCountry in GetAllCountry(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: GetAllCountry) -> ResultMap in value.resultMap }, forKey: "getAllCountries")
      }
    }

    public struct GetAllCountry: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Country"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(Int.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: Int, name: String) {
        self.init(unsafeResultMap: ["__typename": "Country", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: Int {
        get {
          return resultMap["id"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}

public final class GetLeaguesByCountryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetLeaguesByCountry($countryId: Int!) {
      getLeaguesByCountryId(countryId: $countryId) {
        __typename
        id
        name
        division
        country {
          __typename
          id
          name
        }
        confederation
      }
    }
    """

  public let operationName: String = "GetLeaguesByCountry"

  public var countryId: Int

  public init(countryId: Int) {
    self.countryId = countryId
  }

  public var variables: GraphQLMap? {
    return ["countryId": countryId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getLeaguesByCountryId", arguments: ["countryId": GraphQLVariable("countryId")], type: .nonNull(.list(.nonNull(.object(GetLeaguesByCountryId.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getLeaguesByCountryId: [GetLeaguesByCountryId]) {
      self.init(unsafeResultMap: ["__typename": "Query", "getLeaguesByCountryId": getLeaguesByCountryId.map { (value: GetLeaguesByCountryId) -> ResultMap in value.resultMap }])
    }

    public var getLeaguesByCountryId: [GetLeaguesByCountryId] {
      get {
        return (resultMap["getLeaguesByCountryId"] as! [ResultMap]).map { (value: ResultMap) -> GetLeaguesByCountryId in GetLeaguesByCountryId(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: GetLeaguesByCountryId) -> ResultMap in value.resultMap }, forKey: "getLeaguesByCountryId")
      }
    }

    public struct GetLeaguesByCountryId: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["League"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(Int.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("division", type: .nonNull(.scalar(Int.self))),
          GraphQLField("country", type: .nonNull(.object(Country.selections))),
          GraphQLField("confederation", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: Int, name: String, division: Int, country: Country, confederation: String) {
        self.init(unsafeResultMap: ["__typename": "League", "id": id, "name": name, "division": division, "country": country.resultMap, "confederation": confederation])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: Int {
        get {
          return resultMap["id"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var division: Int {
        get {
          return resultMap["division"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "division")
        }
      }

      public var country: Country {
        get {
          return Country(unsafeResultMap: resultMap["country"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "country")
        }
      }

      public var confederation: String {
        get {
          return resultMap["confederation"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "confederation")
        }
      }

      public struct Country: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Country"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(Int.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int, name: String) {
          self.init(unsafeResultMap: ["__typename": "Country", "id": id, "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: Int {
          get {
            return resultMap["id"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }
    }
  }
}
