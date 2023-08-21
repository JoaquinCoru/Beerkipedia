//
//  ContentView.swift
//  Beerkipedia
//
//  Created by Joaquín Corugedo Rodríguez on 21/8/23.
//

import SwiftUI

struct BeerListView: View {
    
    @StateObject var viewModel: BeerListViewModel
    
    @State private var foodFilter: String = ""
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(viewModel.beerList) { beer in
                    NavigationLink {
                        Text(beer.description)
                    } label: {
                        BeerRowView(beer: beer)
                    }
                    
                }
            }
            .navigationTitle("Beers")
            .navigationBarTitleDisplayMode(.inline)
        }.searchable(text: $foodFilter, prompt: "Search by food name...")
            .onChange(of: foodFilter, perform: { newValue in
                
                if newValue != "" {
                    viewModel.getBeers(foodName: newValue)
                } else {
                    viewModel.getBeers()
                }

            })
        .onAppear{
            viewModel.getBeers()
        }
    }
}

struct BeerListView_Previews: PreviewProvider {
    static var previews: some View {
        BeerListView(viewModel: BeerListViewModel())
    }
}
