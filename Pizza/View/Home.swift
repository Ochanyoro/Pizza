//
//  Home.swift
//  Pizza
//
//  Created by 大和田一裕 on 2022/07/29.
//

import SwiftUI

struct Home: View {
    
    // ピザのモデル例
    @State var pizzas: [Pizza] = [
        
        Pizza(breadName: "Bread_1"),
        Pizza(breadName: "Bread_2"),
        Pizza(breadName: "Bread_3"),
        Pizza(breadName: "Bread_4"),
        Pizza(breadName: "Bread_5")
        
    ]
    
    @State var currentPizza: Pizza = .init(breadName: "Bread_1")

    
    
    var body: some View {
        VStack {
            
            // Nav Bar...
            HStack {
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()

                Button {
                    
                } label: {
                    Image(systemName: "suit.heart.fill")
                        .font(.title2)
                        .foregroundColor(.black)
                }

            }
            .overlay(
                Text("Pizza")
                    .font(.title2.bold())
                    .foregroundColor(.black)
            )
            .padding()
            
            
            // Pizza View
            GeometryReader { proxy in
                
                let _ = proxy.size
                
                ZStack {
                    
                    Image("Plate")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 30)
                        .padding(.vertical)
                    
                    // Showing Breads in swipeable Tab...
                    TabView(selection: $currentPizza) {
                        
                        ForEach(pizzas){ pizza in
                            
                            Image(pizza.breadName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(40)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
            }
            .frame(height: 300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
