//
//  InfoView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/09.
//

import SwiftUI

struct InfoView: View {
    @Binding var selectedImage: UIImage?
    @State var title: String = ""
    @State var date = Date()
    @State var tag: String?
    
    var body: some View {
        NavigationView {
            VStack{
                //TODO: 이미지 받아서 보여주기
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Text("No image")
                }
                
                List {
                    HStack{
                        Text("제목")
                        Spacer(minLength: 220)
                        TextField("제목", text: $title)
                            .frame(alignment: .trailing)
                    }
                    .listRowBackground(Color("JoyWhite"))
                    
                    HStack{
                        Text("태그")
                        Spacer(minLength: 230)
                        NavigationLink(destination: InfoTagView(tag: $tag), label: {
                            if tag == nil {
                                Text("없음")
                            }else {
                                Text(tag!)
                            }
                        })
                    }
                    .listRowBackground(Color("JoyWhite"))
                    
                    DatePicker(
                        "날짜",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .tint(Color("JoyBlue"))
                    .listRowBackground(Color("JoyWhite"))
                }
                .scrollContentBackground(.hidden)
            }
            .background(Color("JoyDarkG"))
        }
    }
}

//struct InfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        InfoView()
//    }
//}
