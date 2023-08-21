//
//  BeerListViewModel.swift
//  BeerApp
//
//  Created by Joaquín Corugedo Rodríguez on 18/8/23.
//

import Foundation
import Combine

final class BeerListViewModel: ObservableObject {
    
    private var networkModel: NetworkModel
    
    @Published var beerList: [BeerModel] = []
    @Published var isLoading = false
    @Published var hasError = false
    
    private var suscriptors = Set<AnyCancellable>()
    
    
    init(networkModel: NetworkModel = NetworkModel()) {
        self.networkModel = networkModel
    }
    
    func getBeers(foodName: String? = nil, page: Int = 1) {
        
        isLoading = true
        networkModel.getBeers(foodName: foodName, page: page).sink { completion in
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

        
        
//        { [weak self] result, error in
//
//            DispatchQueue.main.async {
//                self?.isLoading = false
//            }
//
//            if let error {
//                print(error.localizedDescription)
//            }else {
//                if page == 1 {
//                    DispatchQueue.main.async {
//                        self?.beerList = result
//                    }
//
//                } else {
//                    DispatchQueue.main.async {
//                        self?.beerList.append(contentsOf: result)
//                    }
//                }
//            }
//
//        }
    }
    
}
