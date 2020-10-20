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

    func testGetLeaguesByCountry() throws {
        let dataManagerMock = DataManagerMock()
        let viewModel = MainViewModel(dataManagerMock)
        viewModel.getLeaguesByCountry(countryId: 1)
        XCTAssertEqual(viewModel.countryLeagues.count, 1)
        let league = viewModel.countryLeagues[0]
        XCTAssertEqual(league.leagueId, 1)
        XCTAssertEqual(league.name, "MLS")
        XCTAssertEqual(league.country.countryId, 1)
        XCTAssertEqual(league.country.name, "United States")
        XCTAssertEqual(league.confederation, "CONCACAF")
    }

    func testGetYearsForLeague() throws {
        let dataManagerMock = DataManagerMock()
        let viewModel = MainViewModel(dataManagerMock)
        viewModel.getYearsForLeague(leagueId: 1)
        XCTAssertEqual(viewModel.leagueYears.count, 2)
        XCTAssertEqual(viewModel.leagueYears[0], 2020)
        XCTAssertEqual(viewModel.leagueYears[1], 2021)
    }
    
    func testGetClubsForLeagueAndYear() throws {
        let dataManagerMock = DataManagerMock()
        let viewModel = MainViewModel(dataManagerMock)
        viewModel.getClubsForLeagueAndYear(leagueId: 1, year: 2020)
        XCTAssertEqual(viewModel.clubs.count, 1)
        let club = viewModel.clubs[0]
        XCTAssertEqual(club.clubId, 1)
        XCTAssertEqual(club.name, "Seattle Sounders")
        XCTAssertEqual(club.stadiumName, "CenturyLink Field")
        XCTAssertEqual(club.latitude, 47.59506)
        XCTAssertEqual(club.longitude, -122.33163)
    }
    
}
