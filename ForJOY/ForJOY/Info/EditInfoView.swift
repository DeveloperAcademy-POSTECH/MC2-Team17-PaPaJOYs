//
//  EditInfoView.swift
//  ForJOY
//
//  Created by hyebin on 2023/08/21.
//

import SwiftUI
import CoreData

struct EditInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var tag: String?
    @State private var date = Date()
    @State private var isShowAlert = false
    
    var selectedData: Memory
    
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader { geometry in
                    Image(uiImage: UIImage(data: Data(base64Encoded: selectedData.image)!) ?? UIImage(systemName: "house")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width - 30, height: geometry.size.height)
                        .clipped()
                        .padding(.horizontal, 15)
                        .padding(.top, 25)
                }
                
                List {
                    HStack{
                        Text("제목")
                        Spacer(minLength: 100)
                        TextField("\(selectedData.title)", text: $title)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: selectedData.title) { newValue in
                                selectedData.title = String(newValue.prefix(20))
                            }
                    }
                    .listRowBackground(Color("JoyWhite"))
                    
                    HStack {
                        Text("태그")
                            .frame(width: 60, alignment: .leading)
                        Spacer(minLength: 190)
                        NavigationLink(
                            destination: InfoTagView(selectTag: $tag),
                            label: {
                                Text(tag == nil ? selectedData.tag : tag ?? "")
                                    .frame(width: 60, alignment: .trailing)
                            }
                        )
                        .onChange(of: tag) { t in
                            selectedData.tag = t ?? ""
                        }
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
            .navigationBarItems(trailing: DoneButton)
            
            .onAppear() {
                title = selectedData.title
                tag = selectedData.tag == "없음" ? nil : selectedData.tag
                date = selectedData.date
            }
            
            .alert(
                "편집을 취소하시겠습니까?",
                isPresented: $isShowAlert,
                actions: {
                    Button("이어서 편집") { isShowAlert = false }
                    Button("편집 취소") {
                        dismiss()
                    }
                }, message: {
                    Text("편집이 취소되면 수정 사항이 저장되지 않습니다.")
                }
            )
            
        }
    }
    
    private var BackButton: some View {
        Button {
            isShowAlert = true
        } label: {
            Text("취소")
                .foregroundColor(.red)
        }
    }
    
    private var DoneButton: some View {
        Button(
            action: {
                //TODO: Update DB
                CoreDataManager.coreDM.updateMemory(selectedData.objectID, title, tag ?? "없음", date)
                dismiss()
            }, label: {
                Text("저장")
                    .foregroundColor(.blue)
            })
    }
}

struct EditInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EditInfoView(selectedData:Memory(objectID: NSManagedObjectID(),title: "hello", year: 2020, date: Date(), tag: "test", image: "test", voice: ""))
    }
}
