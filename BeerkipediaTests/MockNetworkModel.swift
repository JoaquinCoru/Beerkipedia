//
//  MockNetworkModel.swift
//  BeerkipediaTests
//
//  Created by Joaquín Corugedo Rodríguez on 24/8/23.
//

import Foundation
import Combine

@testable import Beerkipedia

class MockNetworkModel: NetworkModelProtocol {
    
    var fetchDataResult: [BeerModel]?
    
    func getBeers(foodName: String?, page: Int) -> AnyPublisher<[Beerkipedia.BeerModel], Error> {
        if let result = fetchDataResult {
            return Just(result)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.other)
                .eraseToAnyPublisher()
        }
    }
    
    
}
