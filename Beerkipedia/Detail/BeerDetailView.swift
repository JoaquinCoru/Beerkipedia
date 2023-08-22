//
//  BeerDetailView.swift
//  Beerkipedia
//
//  Created by Joaquín Corugedo Rodríguez on 21/8/23.
//

import SwiftUI

struct BeerDetailView: View {
    var beer: BeerModel
     
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: beer.image_url ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding([.top,.horizontal], 10)
                    .frame(height: 200)
            } placeholder: {
                Image("beer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding([.top,.horizontal], 10)
                    .frame(height: 200)
            }
            
            Text(beer.tagline)
                .frame(maxWidth: .infinity ,alignment: .trailing)
                .font(.italic(.body)())
                .padding([.top],5)
            
            Text(beer.name)
                .frame(maxWidth: .infinity ,alignment: .leading)
                .font(.title)
                .bold()
            
            Text(beer.description)
                .padding([.top], 0.1)

            Text("Brewer tips")
                .frame(maxWidth: .infinity ,alignment: .leading)
                .font(.italic(.body)())
                .bold()
                .padding([.top], 0.1)
            
            Text(beer.brewers_tips)
                .frame(maxWidth: .infinity ,alignment: .leading)
                .padding([.top], 0.1)

            
            Spacer()
        }
        .padding([.horizontal], 12)
    }
}

struct BeerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BeerDetailView(beer: BeerModel(id: 1,
                                                          name: "Buzz", tagline: "A Real Bitter Experience.", description: "A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.", image_url: "https://images.punkapi.com/v2/keg.png", brewers_tips: "The earthy and floral aromas from the hops can be overpowering. Drop a little Cascade in at the end of the boil to lift the profile with a bit of citrus.")
            )
        
    }
}
