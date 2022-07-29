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
    
    @State var currentPizza: String = "Bread_1"
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
                
                let size = proxy.size
                
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
                                
                                // ToppingsView
                                ToppingsView(toppings: pizza.toppings, pizza: pizza, width: (size.width / 2) - 45)
                            }
                            // ピザのサイズを変更する
                            .scaleEffect(currentSize == .large ? 1 : (currentSize == .medium ? 0.95 : 0.9))
                            .tag(pizza.breadName)
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
            
            ScrollViewReader { proxy in
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
                                        .opacity(isAdded(topping: topping) ? 0.15 : 0)
                                        .animation(.easeInOut, value: currentPizza)
                                )
                                .padding()
                                .contentShape(Circle())
                                .onTapGesture {
                                    // MARK: Adding/Removing Toppings
                                    if isAdded(topping: topping){
                                        if let index = pizzas[getIndex(breadName: currentPizza)].toppings.firstIndex(where: { currentTopping in
                                            return topping == currentTopping.toppingName
                                        }){
                                            pizzas[getIndex(breadName: currentPizza)].toppings.remove(at: index)
                                        }
                                        
                                        return
                                    }
                                    
                                    // MARK: Creating Some Random Positions
                                    var positions: [CGSize] = []
                                    
                                    for _ in 1...20{
                                        positions.append(.init(width: .random(in: -20...60), height: .random(in: -45...45)))
                                    }
                                    
                                    let toppingObject = Topping(toppingName: topping, randomToppingPositions: positions)
                                    withAnimation{
                                        pizzas[getIndex(breadName: currentPizza)].toppings.append(toppingObject)
                                    }
                                }
                                .tag(topping)
                        }
                    }
                    
                }
                .onChange(of: currentPizza) { _ in
                    withAnimation {
                        proxy.scrollTo(toppings.first ?? "", anchor: .leading)
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
    
    func isAdded(topping: String)->Bool{
        let status = pizzas[getIndex(breadName: currentPizza)].toppings.contains { currentTopping in
            return currentTopping.toppingName == topping
        }
        
        return status
    }
    
    // MARK: Finding Index
    func getIndex(breadName: String)->Int{
        let index = pizzas.firstIndex { pizza in
            return pizza.breadName == breadName
        } ?? 0
        
        return index
    }
    
    
    @ViewBuilder
    func ToppingsView(toppings: [Topping],pizza: Pizza,width: CGFloat)->some View{
        Group{
            ForEach(toppings.indices,id: \.self){index in
                // Each topping consists of 10 topping images....
                let topping = toppings[index]
                
                ZStack{
                    // Adding more Topping Images...
                    // with an illusion...
                    ForEach(1...20,id: \.self){subIndex in
                        // 360/10 = 36....
                        let rotation: Double = Double(subIndex) * 36
                        let crtIndex = (subIndex > 10 ? (subIndex - 10) : subIndex)
                        
                        Image("\(topping.toppingName)_\(crtIndex)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                        // Since index starts from 0...
                            .offset(x: (width / 2) - topping.randomToppingPositions[subIndex - 1].width,y: topping.randomToppingPositions[subIndex - 1].height)
                            .rotationEffect(.init(degrees: rotation))
                        // Spreading Topping into random positions in 360 rotation...
                    }
                }
                // Adding Scaling Animation...
                // Triggering Scaling animation when the topping is added...
                .scaleEffect(topping.isAdded ? 1 : 10,anchor: .center)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                        withAnimation{
                            pizzas[getIndex(breadName: pizza.breadName)].toppings[index].isAdded = true
                        }
                    }
                }
            }
        }
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
