//
//  BeerListView.swift
//  Beerkipedia
//
//  Created by Joaquín Corugedo Rodríguez on 21/8/23.
//

import SwiftUI

struct BeerListView: View {
    @StateObject var viewModel: BeerListViewModel
    
    @State private var foodFilter: String = ""
    
    @State var currentPage: Int = 1
    
    @State private var afterDate: Date = Date.now
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                VStack{
                    DatePicker("Brewed after", selection: $afterDate,
                               displayedComponents: .date)
                    .padding([.horizontal],15)
                    .padding([.top], 2)

                    if (viewModel.beerList.isEmpty){
                        Spacer()
                        Text("No results found")
                            .bold()
                            .font(.title3)
                        Spacer()
                        
                    } else {
                        List{
                            ForEach(viewModel.beerList) { beer in
                                NavigationLink {
                                    BeerDetailView(beer: beer)
                                } label: {
                                    BeerRowView(beer: beer)
                                }
                                
                            }
                            
                            Text("")
                                .font(.italic(.body)())
                                .onAppear(perform:{
                                    
                                    if foodFilter == "" {
                                        viewModel.getBeers(page: currentPage)
                                    } else {
                                        viewModel.getBeers(foodName: foodFilter, page: currentPage)
                                    }
                                    currentPage += 1
                                    
                                })
                        }
                    }

                }

                if (viewModel.isLoading){
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.orange)
                }
                
            }
            .navigationTitle("Beers")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Clear Filters"){
                    print("Applying filters")
                }
            }

        }
        .searchable(text: $foodFilter, prompt: "Search by food name...")
        .onChange(of: foodFilter, perform: { newValue in
            
            if newValue != "" {
                viewModel.getBeers(foodName: newValue)
            } else {
                viewModel.getBeers()
            }
            
        })
        .onChange(of: afterDate) { newValue in
            print(newValue)
        }
        .onAppear {
            viewModel.getBeers()
        }
        .alert(isPresented: $viewModel.hasError) {
            return Alert(title: Text("Alert"),
                         message: Text("Network Error") )
        }
    }
}

struct BeerListView_Previews: PreviewProvider {
    static var previews: some View {
        BeerListView(viewModel: BeerListViewModel())
    }
}
