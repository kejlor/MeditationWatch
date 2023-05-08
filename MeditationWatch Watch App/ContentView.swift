//
//  ContentView.swift
//  MeditationWatch Watch App
//
//  Created by Bartosz Wojtkowiak on 08/05/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: HealthKitManager
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        VStack {
            Spacer()
            
            Group {
                Text(manager.message)
                
                Text(manager.description)
            }
            .lineLimit(1)
            .fixedSize(horizontal: false, vertical: true)
            .font(.title3)
            
            Spacer()
            
            HStack {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(manager.backgroundColor)
                    .scaleEffect(animationAmount)
                    .animation(
                        .linear(duration: manager.durationValue)
                            .delay(0.2)
                            .repeatForever(autoreverses: true),
                        value: animationAmount)
                    .onAppear {
                        animationAmount = 1.2
                    }
                
                Text("\(manager.value)")
                    .fontWeight(.regular)
                    .font(.largeTitle)
                    .foregroundColor(manager.backgroundColor)
                
                Text("BPM")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding(.bottom, 28.0)
            }
            
            Spacer()
        }
        .padding()
        .onAppear(perform: manager.start)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
