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
                               in: ...Date() ,
                               displayedComponents: .date)
                    .padding([.horizontal],15)
                    .padding([.top], 2)

                    if (viewModel.beerList.isEmpty && !viewModel.isLoading){
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
                                    
                                    viewModel.getBeers(foodName: foodFilter, page: currentPage, brewedAfterDate: afterDate)
                                    
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
                    foodFilter = ""
                    afterDate = Date.now
                }
            }
            
        }
        .searchable(text: $foodFilter, prompt: "Search by food name...")
        .onChange(of: foodFilter, perform: { newValue in
            
            viewModel.getBeers(foodName: newValue, brewedAfterDate: afterDate)
            
        })
        .onChange(of: afterDate) { newValue in
            
            viewModel.getBeers(
                foodName: foodFilter, brewedAfterDate: newValue
            )
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
