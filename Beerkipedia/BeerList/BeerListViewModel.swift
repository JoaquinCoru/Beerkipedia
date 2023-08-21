//
//  BeerListViewModel.swift
//  BeerApp
//
//  Created by Joaquín Corugedo Rodríguez on 18/8/23.
//

import Foundation


final class BeerListViewModel: ObservableObject {
    
    private var networkModel: NetworkModel
    
    @Published var beerList: [BeerModel] = []
    @Published var isLoading = false
    
    
    init(networkModel: NetworkModel = NetworkModel()) {
        self.networkModel = networkModel
    }
    
    func getBeers(foodName: String? = nil, page: Int = 1) {
        
        isLoading = true
        networkModel.getBeers(foodName: foodName, page: page) { [weak self] result, error in
            
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            
            if let error {
                print(error.localizedDescription)
            }else {
                if page == 1 {
                    DispatchQueue.main.async {
                        self?.beerList = result
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self?.beerList.append(contentsOf: result)
                    }
                }
            }
            
        }
    }
    
}
