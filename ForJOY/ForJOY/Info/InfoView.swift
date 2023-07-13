//
//  InfoView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/09.
//

import SwiftUI

struct InfoView: View {
    @EnvironmentObject var realmManger: RealmManger
    
    @State var title: String = ""
    @State var date = Date()
    @State var tag: String?
    @State var toAddDoneView = false
    @State var isAddData: Bool = false
    
    @Binding var selectedImage: UIImage?
    @Binding var recording: URL?
    
    var body: some View {
        NavigationStack {
            VStack{
                if selectedImage != nil {
                    GeometryReader { geometry in
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width - 30, height: geometry.size.height)
                            .clipped()
                            .padding(.horizontal, 15)
                            .padding(.top, 25)
                    }
                } else {
                    Text("No image")
                }
                
                List {
                    HStack{
                        Text("제목")
                        Spacer(minLength: 100)
                        TextField("제목", text: $title)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: title) { newValue in
                                title = String(newValue.prefix(20))
                            }
                    }
                    .listRowBackground(Color("JoyWhite"))
                    
                    HStack(){
                        Text("태그")
                            .frame(width: 60, alignment: .leading)
                        Spacer(minLength: 190)
                        NavigationLink(destination: InfoTagView(selectTag: $tag), label: {
                            if tag == nil {
                                Text("없음")
                                    .frame(width: 60, alignment: .trailing)
                            }else {
                                Text(tag!)
                                    .frame(width: 60, alignment: .trailing)
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
                    Button(
                        action: {
                            toAddDoneView = true
                        },
                        label: {
                            NavigationLink(
                                isActive: $toAddDoneView,
                                destination:  {
                                    AddDoneView()
                                        .navigationBarBackButtonHidden()
                                        .onAppear(){
                                            if !isAddData {
                                                if title != "" {
                                                    let year = Int(date.toString(dateFormat: "yyyy"))!
                                                    
                                                    realmManger.addMemories(Memory(value: [
                                                        "title": title,
                                                        "year": year,
                                                        "date": date,
                                                        "tag": tag ?? "기본",
                                                        "image": selectedImage!.jpegData(compressionQuality: 0.5)!,
                                                        "voice": recording!.absoluteString
                                                    ] as [String : Any] ))
                                                    isAddData = true
                                                }
                                            }
                                        }
                                },
                                label: {
                                    Text("Done")
                                }
                            )
                            .isDetailLink(false)
                            .background(Color("JoyDarkG"))
                        }
                    )
                    .disabled(title == "")
                }
            }
            .tint(Color("JoyBlue"))
        }
    }
}
