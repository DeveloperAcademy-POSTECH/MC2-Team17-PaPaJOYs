//
//  InfoView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/09.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var title: String = ""
    @State var date = Date()
    @State var tag: String?
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack{
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
                        NavigationLink(destination: InfoTagView(selectTag: $tag), label: {
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
                .scrollDisabled(true)
            }
            .background(Color("JoyDarkG"))
            .foregroundColor(.black)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                    }, label: {
                        NavigationLink(
                            destination:  {
                                AddDoneView()
                            }, label: {
                                Text("Done")
                            })
                    })
                }
            }
            .gesture(DragGesture(minimumDistance: 3.0,
                                 coordinateSpace: .local)
                .onEnded({ (value) in
                    if value.translation.width > 0 {
                        self.presentationMode.wrappedValue.dismiss()
                    }
            }))
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(selectedImage: .constant(UIImage(named: "test")))
    }
}
