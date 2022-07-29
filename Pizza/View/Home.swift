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
    @State var currentSize: PizzaSize = .medium
    
    // smoothなエフェクトをかける
    @Namespace var animation
    
    let toppings: [String] = ["Basil","Onion","Broccoli","Mushroom","Sausage"]

    
    
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
                            
                            ZStack {
                                Image(pizza.breadName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(40)
                            }
                            // ピザのサイズを変更する
                            .scaleEffect(currentSize == .large ? 1 : (currentSize == .medium ? 0.95 : 0.9))
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
            }
            .frame(height: 300)
            
            // 値段
            Text("1700円")
                .font(.title.bold())
                .foregroundColor(.black)
                .padding(.top, 10)
            
            
            
            // ピザのサイズ
            HStack(spacing: 20) {
                ForEach(PizzaSize.allCases, id: \.rawValue) { size in
                    
                    Button {
                        
                        withAnimation {
                            currentSize = size
                        }
                        
                    } label: {
                        Text(size.rawValue)
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                            .background(
                                ZStack {
                                    if currentSize == size {
                                        Color.white
                                            .clipShape(Circle())
                                        // かげ
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                                            .shadow(color: Color.black.opacity(0.03), radius: 5, x: -5, y: -5)
                                            .matchedGeometryEffect(id: "SIZEINDICATOR", in: animation)
                                    }
                                }
                            )
                            
                        
                    }

                }
            }
            .padding(.top, 10)
            
            // トッピングのカスタム
            Text("トッピングのカスタム")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 25)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -10){
                    ForEach(toppings, id: \.self) { topping in
                        // トッピング画像の表示
                        // それぞれのトッピングに１０枚ずつある
                        Image("\(topping)_3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .padding(12)
                            .background(
                                
                                Color.green
                                    .clipShape(Circle())
                                    .opacity(0.15)
                            )
                            .padding()
                            .contentShape(Circle())
                            .onTapGesture {
                                // トッピングを加える
                            }
                    }
                }
                
            }
            
            // カートに加える
            Button {
                
            } label: {
                HStack(spacing: 15) {
                    Image(systemName: "cart.fill")
                        .font(.title2)
                    
                    Text("カートに入れる")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 30)
                .background(Color("Brown"), in: RoundedRectangle(cornerRadius: 15))
            }
            .frame(maxHeight: .infinity, alignment: .center)

            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


enum PizzaSize: String, CaseIterable {
    case small = "S"
    case medium = "M"
    case large = "L"
}
