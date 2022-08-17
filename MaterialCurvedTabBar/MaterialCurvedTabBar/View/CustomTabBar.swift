//
//  CustomTabBar.swift
//  MaterialCurvedTabBar
//
//  Created by Md Shah Alam on 7/18/22.
//

import SwiftUI

// This App will work for Both iOS 14/15...
struct CustomTabBar: View {
    
    // Current Tab...
    @State var currentTab: Tab = .Home
    
    // Hiding Tab Bar...
    init(){
        UITabBar.appearance().isHidden = true
    }
    
    // Matched Geometry effect...
    @Namespace var animation
    
    // Current Tab XValue...
    @State var currentXValue: CGFloat = 0
    
    var body: some View {
        TabView(selection: $currentTab) {
            SampleCards(color: .purple, count: 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BG").ignoresSafeArea())
                .tag(Tab.Home)
            
            Text("Search")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BG").ignoresSafeArea())
                .tag(Tab.Search)
            
            Text("Notifications")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BG").ignoresSafeArea())
                .tag(Tab.Notifications)
            
            Text("Settings")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BG").ignoresSafeArea())
                .tag(Tab.Account)
        }
        // Curved Tab Bar...
        .overlay(
            HStack(spacing: 0){
                ForEach(Tab.allCases, id: \.rawValue){tab in
                    TabButton(tab: tab)
                }
            }
                .padding(.vertical)
                // Perview wont show safeArea...
                .padding(.bottom, getSafeArea().bottom == 0 ? 10 : (getSafeArea().bottom - 10))
                .background(
                    MaterialEffect(style: .systemUltraThinMaterialDark)
                        .clipShape(BottomCurve(currentXValue: currentXValue))
                )
            , alignment: .bottom
        )
        .ignoresSafeArea(.all, edges: .bottom)
        // Always Dark...
        .preferredColorScheme(.dark)
    }
    
    // Smaple Cards...
    @ViewBuilder
    func SampleCards(color: Color, count: Int) -> some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 15){
                    ForEach(1...count, id: \.self){ index in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color)
                            .frame(height: 250)
                    }
                }
                .padding()
                // Approx Bottom Padding...
                // 30 Size...
                // Padding = 30....
                // Bottom Edg...
                .padding(.bottom, 30)
                .padding(.bottom, getSafeArea().bottom == 0 ? 15 : getSafeArea().bottom)
            }
        }
        .navigationBarTitle("Home")
    }
    
    //TabButton...
    @ViewBuilder
    func TabButton(tab: Tab) -> some View {
        
        // Since we need XAxis Value for Curved...
        GeometryReader{proxy in
            Button{
                withAnimation(.spring()){
                    currentTab = tab
                    // Updating value...
                    currentXValue = proxy.frame(in: .global).midX
                }
            } label: {
                
                // Moving Button up for current Tab...
                
                Image(systemName: tab.rawValue)
                // Since we need perfect value for Curved...
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(currentTab == tab ? 15 : 0)
                    .background(
                        ZStack{
                            if currentTab == tab {
                                MaterialEffect(style: .systemUltraThinMaterialDark)
                                    .clipShape(Circle())
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
                    .contentShape(Rectangle())
                    .offset(y: currentTab == tab ? -50 : 0)
            }
            // Setting intial Curve Position...
            .onAppear {
                if tab == Tab.allCases.first && currentXValue == 0 {
                    currentXValue = proxy.frame(in: .global).midX
                }
            }
        }
        .frame(height: 30)
        // MaxSize...
    }
    
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar()
    }
}

// To Iterate...
// Enum for Tab...
enum Tab: String, CaseIterable {
    
    // Raw Value must be image Name in assets...
    case Home = "house.fill"
    case Search = "magnifyingglass"
    case Notifications = "bell.fill"
    case Account = "person.fill"
}

// Getting Safe Area...
extension View{
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        return safeArea
    }
}
