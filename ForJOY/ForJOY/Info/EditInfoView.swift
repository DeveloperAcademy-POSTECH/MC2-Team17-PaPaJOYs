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
    @State private var showTagView = false
    
    var selectedData: Memory
    let padding = UIScreen.height/844
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(uiImage: UIImage(data: Data(base64Encoded: selectedData.image)!) ?? UIImage(named: "test")!)
                    .resizable()
                    .aspectRatio(CGSize(width: 3, height: 4), contentMode: .fill)
                    .frame(width: 350*padding, height: 466*padding)
                    .cornerRadius(10)
                    .clipped()
                    .padding(.horizontal, 15)
                    .padding(.top, 30*padding)
                
                List {
                    HStack{
                        Text("제목")
                        Spacer(minLength: 0)
                        TextField("\(selectedData.title)", text: $title)
                            .accentColor(.joyBlue)
                            .font(.system(size: (17.0 - CGFloat(selectedData.title.count)*0.3)))
                            .multilineTextAlignment(.trailing)
                            .onChange(of: selectedData.title) { newValue in
                                selectedData.title = String(newValue.prefix(20))
                            }
                            .padding(.trailing, 4)
                    }
                    .listRowBackground(Color.joyWhite)
                    
                    HStack {
                        Text("태그")
                            .frame(width: 60, alignment: .leading)
                        
                        Spacer(minLength: 0)
                        
                        Button(
                            action: {showTagView = true},
                            label: {
                                Text(tag ?? "없음")
                                    .frame(maxWidth: 250, alignment: .trailing)
                            }
                        )
                    }
                    .listRowBackground(Color.joyWhite)
                    
                    DatePicker(
                        "날짜",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .tint(Color.joyBlue)
                    .listRowBackground(Color.joyWhite)
                }
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
            }
            .background(Color.joyBlack)
            .foregroundColor(.black)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton)
            .navigationBarItems(trailing: DoneButton)
            
            .onAppear() {
                title = selectedData.title
                tag = selectedData.tag == "없음" ? nil : selectedData.tag
                date = selectedData.date
            }
            
            .alert("편집을 취소하시겠습니까?", isPresented: $isShowAlert, actions: {
                Button("이어서 편집", role: .cancel) { }
                Button("편집 취소", role: .destructive) { dismiss() }
            }, message: {
                Text("편집이 취소되면 수정 사항이 저장되지 않습니다.")
            })
            
            .sheet(isPresented: $showTagView) {
                InfoTagView(selectTag: $tag, showTagView: $showTagView)
            }
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
                CoreDataManager.coreDM.updateMemory(selectedData.objectID, title, tag ?? "없음", date)
                
                selectedData.title = title
                selectedData.tag = tag ?? "없음"
                selectedData.date = date
                
                dismiss()
            }, label: {
                Text("저장")
                    .foregroundColor(Color.joyBlue)
            })
    }
}

struct EditInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EditInfoView(selectedData:Memory(objectID: NSManagedObjectID(),title: "hello", year: 2020, date: Date(), tag: "test", image: "test", voice: ""))
    }
}
