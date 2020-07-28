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
