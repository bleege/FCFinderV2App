//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Brad Leege on 7/7/20.
//

import XCTest
@testable import FCFinderV2App

class MainViewModelTests: XCTestCase {

    func testGetCountries() throws {
        let dataManagerMock = DataManagerMock()
        let viewModel = MainViewModel(dataManagerMock)
        viewModel.loadAllCountries()
        XCTAssertEqual(viewModel.countries.count, 2)
        let country = viewModel.countries[0]
        XCTAssertEqual(country.countryId, 1)
        XCTAssertEqual(country.name, "United States")
    }

}
