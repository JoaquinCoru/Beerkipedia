//
//  BeerRowView.swift
//  Beerkipedia
//
//  Created by Joaquín Corugedo Rodríguez on 21/8/23.
//

import SwiftUI

struct BeerRowView: View {
    
    var beer: BeerModel
    
    var body: some View {
        HStack (alignment: .center){
            AsyncImage(url: URL(string: beer.image_url ?? "")) { imageDownload in
                
                imageDownload
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
            } placeholder: {
                Image("beer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
            
            VStack (alignment: .leading, spacing: 10 ){
                Text(beer.name)
                    .font(.title3)
                    .bold()
                
                Text(beer.tagline)
                    .font(.italic(.body)())
            }
        }.padding([.vertical], 5)
    }
}

struct BeerRowView_Previews: PreviewProvider {
    static var previews: some View {
        BeerRowView(beer: BeerModel(id: 1,
                                    name: "Buzz", tagline: "A Real Bitter Experience.", description: "A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.", image_url: "https://images.punkapi.com/v2/keg.png", brewers_tips: "The earthy and floral aromas from the hops can be overpowering. Drop a little Cascade in at the end of the boil to lift the profile with a bit of citrus.",
                                    food_pairing: [
                                        "Spicy chicken tikka masala",
                                        "Grilled chicken quesadilla",
                                        "Caramel toffee cake"
                                    ],
                                    first_brewed: "09/2007"
                                   )
                    
        )
        
    }
}
