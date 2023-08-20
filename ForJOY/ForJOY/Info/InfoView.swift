//
//  InfoView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/09.
//

import SwiftUI

struct InfoView: View {
    @State var title: String = ""
    @State var date = Date()
    @State var tag: String?
    @State var toAddDoneView = false
    @State var isAddData: Bool = false
    @State private var pushBackButton = false
    
    @Binding var selectedImage: UIImage?
    @Binding var recording: URL?
    @Binding var pageNumber: Int
    
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
            .navigationBarItems(leading: BackButton)
            .alert("다시 녹음하시겠습니까?", isPresented: $pushBackButton, actions: {
                Button("취소", role: .cancel) { }
                Button("다시 녹음", role: .destructive) { pageNumber = 0 }
            }, message: {
                Text("재녹음 시 이전에 녹음된 정보는 삭제됩니다.")
            })
            
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
                                        .onAppear(){
                                            if !isAddData {
                                                if title != "" {
                                                    let year = Int(date.toString(dateFormat: "yyyy"))!
                                                    
                                                    CoreDataManager.coreDM.addMemory(title, Int16(year), date, tag ?? "기본", selectedImage!.jpegData(compressionQuality: 0.8)!.base64EncodedString(), recording!.absoluteString)
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
    
    private var BackButton: some View {
        Button {
            pushBackButton = true
        } label: {
            Text("\(Image(systemName: "chevron.backward")) 다시 녹음")
        }
    }
}
