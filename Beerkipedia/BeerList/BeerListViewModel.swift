//
//  BeerListViewModel.swift
//  BeerApp
//
//  Created by Joaquín Corugedo Rodríguez on 18/8/23.
//

import Foundation
import Combine

final class BeerListViewModel: ObservableObject {
    
    private var networkModel: NetworkModelProtocol
    
    @Published var beerList: [BeerModel] = []
    @Published var isLoading = false
    @Published var hasError = false
    
    private var suscriptors = Set<AnyCancellable>()
    
    
    init(networkModel: NetworkModelProtocol = NetworkModel()) {
        self.networkModel = networkModel
    }
    
    func getBeers(foodName: String = "", page: Int = 1, brewedAfterDate: Date? = nil) {
        
        var dateString = ""
        
        if let date = brewedAfterDate {
            
            if (date.convertFromDateToFormattedString() != Date.now.convertFromDateToFormattedString()) {
                dateString = date.convertFromDateToFormattedString()
            }
            
        }
        
        isLoading = true
        networkModel.getBeers(foodName: foodName, page: page, afterBrewedDate: dateString).sink { completion in
            switch completion {
                
            case .finished:
                self.isLoading = false
            case .failure(let error):
                self.hasError = true
                self.isLoading = false
                print("Error \(error.localizedDescription)")
            }
        } receiveValue: {[weak self] result in
            if page == 1 {
                self?.beerList = result
            } else {
                self?.beerList.append(contentsOf: result)
            }

        }
        .store(in: &suscriptors)
    }
    
}
