//
//  CardView.swift
//  CarouselTutorial
//
//  Created by Sunjoo IM on 2023/05/04.
//

import SwiftUI

struct CardView: View {
    
    @State var textfield_val = ""
    // 재생버튼 토글 각각 따로 설정해야함
    @State var isPlaying = false
    
    var body: some View {
        CarouselView(itemHeight: 510, views: [
            // Card 1
            AnyView(
                VStack{
                    Image("1")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .clipped()
                        .shadow(radius: 3)
                        .padding()
                        .padding(.top)
                    
                    VStack {
                        Text("애플디벨로퍼아카데미 @포스텍")
                        //                            .foregroundColor(Color("JoyDarkG"))
                            .font(.title3)
                            .bold()
                            .frame(width: 300, alignment: .leading)
                            .allowsTightening(true)
                            .padding(.leading, 51)
                        //                            .border(.red)
                        Text("2023.05.03")
                            .foregroundColor(Color("JoyLightG"))
                            .frame(width: 300, alignment: .leading)
                            .padding(.leading, 51)
                        //                            .border(.blue)
                        
                    }
                    
                    HStack(spacing: 10){
                        Spacer().frame(width: 14)
                        
                        Button {
                            isPlaying.toggle()
                        } label: {
                            Label("Toggle Play", systemImage: isPlaying ? "headphones.circle.fill" : "headphones.circle")
                                .labelStyle(.iconOnly)
                                .font(.system(size: 30))
                                .foregroundColor(Color("JoyBlue"))
                        }
                        
                        ProgressView(value: 0.3)
                        
                        Text("01:24")
                            .foregroundColor(Color("JoyLightG"))
                        
                        Spacer().frame(width: 16)
                    }
                    
                    Spacer()
                }
            ),
            // Card 2
            AnyView(
                VStack{
                    Image("2")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .clipped()
                        .shadow(radius: 3)
                        .padding()
                        .padding(.top)
                    
                    VStack {
                        Text("마운틴듀 먹는 아기")
                        //                            .foregroundColor(Color("JoyDarkG"))
                            .font(.title3)
                            .bold()
                            .frame(width: 300, alignment: .leading)
                            .allowsTightening(true)
                            .padding(.leading, 51)
                        //                            .border(.red)
                        Text("2023.05.03")
                            .foregroundColor(Color("JoyLightG"))
                            .frame(width: 300, alignment: .leading)
                            .padding(.leading, 51)
                        //                            .border(.blue)
                        
                    }
                    
                    HStack(spacing: 10){
                        Spacer().frame(width: 14)
                        
                        Button {
                            isPlaying.toggle()
                        } label: {
                            Label("Toggle Play", systemImage: isPlaying ? "headphones.circle.fill" : "headphones.circle")
                                .labelStyle(.iconOnly)
                                .font(.system(size: 30))
                                .foregroundColor(Color("JoyBlue"))
                        }
                        
                        ProgressView(value: 0.3)
                        
                        Text("01:24")
                            .foregroundColor(Color("JoyLightG"))
                        
                        Spacer().frame(width: 16)
                    }
                    
                    Spacer()
                }
            ),
            // Card 3
            AnyView(
                VStack{
                    Image("3")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .clipped()
                        .shadow(radius: 3)
                        .padding()
                        .padding(.top)
                    
                    VStack {
                        Text("마조리카 아기")
                        //                            .foregroundColor(Color("JoyDarkG"))
                            .font(.title3)
                            .bold()
                            .frame(width: 300, alignment: .leading)
                            .allowsTightening(true)
                            .padding(.leading, 51)
                        //                            .border(.red)
                        Text("2023.05.03")
                            .foregroundColor(Color("JoyLightG"))
                            .frame(width: 300, alignment: .leading)
                            .padding(.leading, 51)
                        //                            .border(.blue)
                        
                    }
                    
                    HStack(spacing: 10){
                        Spacer().frame(width: 14)
                        
                        Button {
                            isPlaying.toggle()
                        } label: {
                            Label("Toggle Play", systemImage: isPlaying ? "headphones.circle.fill" : "headphones.circle")
                                .labelStyle(.iconOnly)
                                .font(.system(size: 30))
                                .foregroundColor(Color("JoyBlue"))
                        }
                        
                        ProgressView(value: 0.3)
                        
                        Text("01:24")
                            .foregroundColor(Color("JoyLightG"))
                        
                        Spacer().frame(width: 16)
                    }
                    
                    Spacer()
                }
            ),
            // Card 4
            AnyView(
                VStack{
                    Image("4")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .clipped()
                        .shadow(radius: 3)
                        .padding()
                        .padding(.top)
                    
                    VStack {
                        Text("아기상어 스티커 덕지덕지 아기")
                        //                            .foregroundColor(Color("JoyDarkG"))
                            .font(.title3)
                            .bold()
                            .frame(width: 300, alignment: .leading)
                            .allowsTightening(true)
                            .padding(.leading, 51)
                        //                            .border(.red)
                        Text("2023.05.03")
                            .foregroundColor(Color("JoyLightG"))
                            .frame(width: 300, alignment: .leading)
                            .padding(.leading, 51)
                        //                            .border(.blue)
                        
                    }
                    
                    HStack(spacing: 10){
                        Spacer().frame(width: 14)
                        
                        Button {
                            isPlaying.toggle()
                        } label: {
                            Label("Toggle Play", systemImage: isPlaying ? "headphones.circle.fill" : "headphones.circle")
                                .labelStyle(.iconOnly)
                                .font(.system(size: 30))
                                .foregroundColor(Color("JoyBlue"))
                        }
                        
                        ProgressView(value: 0.3)
                        
                        Text("01:24")
                            .foregroundColor(Color("JoyLightG"))
                        
                        Spacer().frame(width: 16)
                    }
                    
                    Spacer()
                }
            ),
            // Card 5
            AnyView(
                VStack{
                    Image("5")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .clipped()
                        .shadow(radius: 3)
                        .padding()
                        .padding(.top)
                    
                    VStack {
                        Text("카와이😍")
                        //                            .foregroundColor(Color("JoyDarkG"))
                            .font(.title3)
                            .bold()
                            .frame(width: 300, alignment: .leading)
                            .allowsTightening(true)
                            .padding(.leading, 51)
                        //                            .border(.red)
                        Text("2023.05.03")
                            .foregroundColor(Color("JoyLightG"))
                            .frame(width: 300, alignment: .leading)
                            .padding(.leading, 51)
                        //                            .border(.blue)
                        
                    }
                    
                    HStack(spacing: 10){
                        Spacer().frame(width: 14)
                        
                        Button {
                            isPlaying.toggle()
                        } label: {
                            Label("Toggle Play", systemImage: isPlaying ? "headphones.circle.fill" : "headphones.circle")
                                .labelStyle(.iconOnly)
                                .font(.system(size: 30))
                                .foregroundColor(Color("JoyBlue"))
                        }
                        
                        ProgressView(value: 0.3)
                        
                        Text("01:24")
                            .foregroundColor(Color("JoyLightG"))
                        
                        Spacer().frame(width: 16)
                    }
                    
                    Spacer()
                }
            ),
            // Card 6
            AnyView(
                VStack{
                    Image("6")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .clipped()
                        .shadow(radius: 3)
                        .padding()
                        .padding(.top)
                    
                    VStack {
                        Text("사진 사이즈 조정 어떻게하니")
                        //                            .foregroundColor(Color("JoyDarkG"))
                            .font(.title3)
                            .bold()
                            .frame(width: 300, alignment: .leading)
                            .allowsTightening(true)
                            .padding(.leading, 51)
                        //                            .border(.red)
                        Text("2023.05.03")
                            .foregroundColor(Color("JoyLightG"))
                            .frame(width: 300, alignment: .leading)
                            .padding(.leading, 51)
                        //                            .border(.blue)
                        
                    }
                    
                    HStack(spacing: 10){
                        Spacer().frame(width: 14)
                        
                        Button {
                            isPlaying.toggle()
                        } label: {
                            Label("Toggle Play", systemImage: isPlaying ? "headphones.circle.fill" : "headphones.circle")
                                .labelStyle(.iconOnly)
                                .font(.system(size: 30))
                                .foregroundColor(Color("JoyBlue"))
                        }
                        
                        ProgressView(value: 0.3)
                        
                        Text("01:24")
                            .foregroundColor(Color("JoyLightG"))
                        
                        Spacer().frame(width: 16)
                    }
                    
                    Spacer()
                }
            ),
            // Card 7
            AnyView(
                VStack{
                    Image("7")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .clipped()
                        .shadow(radius: 3)
                        .padding()
                        .padding(.top)
                    
                    VStack {
                        Text("사진 크기 어케 맞추니")
                        //                            .foregroundColor(Color("JoyDarkG"))
                            .font(.title3)
                            .bold()
                            .frame(width: 300, alignment: .leading)
                            .allowsTightening(true)
                            .padding(.leading, 51)
                        //                            .border(.red)
                        Text("2023.05.03")
                            .foregroundColor(Color("JoyLightG"))
                            .frame(width: 300, alignment: .leading)
                            .padding(.leading, 51)
                        //                            .border(.blue)
                        
                    }
                    
                    HStack(spacing: 10){
                        Spacer().frame(width: 14)
                        
                        Button {
                            isPlaying.toggle()
                        } label: {
                            Label("Toggle Play", systemImage: isPlaying ? "headphones.circle.fill" : "headphones.circle")
                                .labelStyle(.iconOnly)
                                .font(.system(size: 30))
                                .foregroundColor(Color("JoyBlue"))
                        }
                        
                        ProgressView(value: 0.3)
                        
                        Text("01:24")
                            .foregroundColor(Color("JoyLightG"))
                        
                        Spacer().frame(width: 16)
                    }
                    
                    Spacer()
                }
            )
        ])
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
        
    }
}