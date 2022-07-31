//
//  SeatViewModelTests.swift
//  SeatViewModelTests
//
//  Created by KC on 05/06/2022.
//

import XCTest
@testable import MovieBookingApp
import RxSwift
import RxCocoa
import Combine

class SeatViewModelTests: XCTestCase {
    
    var viewModel: MovieSeatViewModel!
    var checkOutModel: MockCheckOutModel!
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        checkOutModel = MockCheckOutModel()
        viewModel = MovieSeatViewModel(checkOutModel: checkOutModel)
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        checkOutModel = nil
        viewModel = nil
    }
    
    
    func test_fetchAllSeatPlanData_returnsAllItemsSuccss() throws{
       
        viewModel.fetchSeating()
        
        XCTAssertGreaterThan(viewModel.seatList.count, 0)
    }
    
    func test_fetchAllSeatPlanData_invalidInputData_returnsEmpty() throws{
        checkOutModel.validInputs = false
        viewModel.fetchSeating()
        XCTAssertEqual(viewModel.seatList.count, 0)
           
    }
    
    func test_fetchMovieData_returnsSuccess() throws{
        viewModel.fetchCheckOut()
        XCTAssertEqual(viewModel.checkOut.movieId, 414906)
    }
    
    func test_tapComboSetNavigation_withoutChosingSeat_returnsAlert() throws{
       
        
        
    }

   
}

