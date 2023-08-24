//
//  BeerListViewModelTests.swift
//  BeerkipediaTests
//
//  Created by Joaquín Corugedo Rodríguez on 24/8/23.
//

import XCTest
@testable import Beerkipedia

final class BeerListViewModelTests: XCTestCase {
    
    var networkModel: MockNetworkModel?
    var viewModel: BeerListViewModel?
    
    let mockBeerResult = BeerModel(id: 1,
                                   name: "Buzz", tagline: "A Real Bitter Experience.", description: "A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.", image_url: "https://images.punkapi.com/v2/keg.png", brewers_tips: "The earthy and floral aromas from the hops can be overpowering. Drop a little Cascade in at the end of the boil to lift the profile with a bit of citrus.",
                                   food_pairing: [
                                    "Spicy chicken tikka masala",
                                    "Grilled chicken quesadilla",
                                    "Caramel toffee cake"
                                   ]
    )
    
    override func setUp() {
        networkModel = MockNetworkModel()
        if let networkModel {
            viewModel = BeerListViewModel(networkModel: networkModel)
        }
    }
    
    func testGetBeersResultEqualToNetworkSuccessResult() {
        //Given
        networkModel?.fetchDataResult = [mockBeerResult]
        
        //when
        viewModel?.getBeers()
        
        let cancellable = viewModel?.$beerList
            .sink(receiveCompletion: { completion in
                switch completion {
                    
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail("Publisher failed with error: \(error)")
                }
            }, receiveValue: { _ in
                //Then
                XCTAssertEqual(self.viewModel?.beerList[0].name, self.mockBeerResult.name)
                
                XCTAssert(self.viewModel?.hasError == false)
            })
        
    }
    
    func testGetBeersNetworkErrorHasErrorTrue() {
        //Given
        networkModel?.fetchDataResult = nil
        
        //When
        viewModel?.getBeers()
        
        let cancellable = viewModel?.$beerList
            .sink(receiveCompletion: { completion in
                switch completion {
                    
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail("Publisher failed with error: \(error)")
                }
            }, receiveValue: { _ in
                if let viewModel = self.viewModel {
                    XCTAssert(viewModel.beerList.isEmpty)
                    XCTAssert(viewModel.hasError)
                }
            })
    }
    
}
