//
//  TrainingTests.swift
//  TrainingTests
//
//  Created by Thibault Ballof on 02/02/2023.
//

import XCTest
import RxSwift

import SDWebImage
@testable import training

final class TrainingTests: XCTestCase {

    let service = GetMoviesMockService()
    let disposeBag = DisposeBag()

    func testFetchMoviesWithGoodData() {
        service.dataMock = .goodData
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        service.fetchMovies(type: MoviesResults.self).subscribe { response in
            XCTAssertNotNil(response.results)
            XCTAssertEqual(response.results.first?.title, "Shotgun Wedding")
            XCTAssertEqual(response.results.count, 2)
            expectation.fulfill()
        }.disposed(by: disposeBag)

        wait(for: [expectation], timeout: 10)
    }

    func testFetchMoviesWithBadData() {
        service.dataMock = .badData
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        var errorValue: Error?
        service.fetchMovies(type: MoviesResults.self).subscribe(onError: { error in
            errorValue = error
            XCTAssertNotNil(errorValue)
            expectation.fulfill()
        }).disposed(by: disposeBag)

        wait(for: [expectation], timeout: 10)
    }

    func testModelWithGoodData() {
        let model = Movie(backdropPath: "/t79ozwWnwekO0ADIzsFP1E5SkvR.jpg", title: "Shotgun Wedding", posterPath: "/t79ozwWnwekO0ADIzsFP1E5SkvR.jpg", releaseDate: "", overview: "Darcy and Tom gather their families for the ultimate destination wedding but when the entire party is taken hostage, “’Til Death Do Us Part” takes on a whole new meaning in this hilarious, adrenaline-fueled adventure as Darcy and Tom must save their loved ones—if they don’t kill each other first.")
        XCTAssertNotNil(model.title)
        XCTAssertNotNil(model.overview)
        XCTAssertNotNil(model.backdropPath)
    }

    func testFetchMoviesWithNilData() {
        service.dataMock = .badDataWithNilValue
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        var errorValue: Error?
        service.fetchMovies(type: MoviesResults.self).subscribe(onError: { error in
            errorValue = error
            XCTAssertNotNil(errorValue)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 10)
    }
}

