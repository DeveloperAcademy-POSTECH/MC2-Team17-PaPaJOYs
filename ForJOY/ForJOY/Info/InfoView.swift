//
//  InfoView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/09.
//

import SwiftUI

// 사용자에게 메모리 정보(이미지, 제목, 날짜, 태그 등)를 입력받기 위한 뷰
struct InfoView: View {
    // Realm 데이터베이스 관리자
    @EnvironmentObject var realmManger: RealmManger
    
    // 사용자에게 입력받을 정보의 상태 변수들
    @State var title: String = ""
    @State var date = Date()
    @State var tag: String?
    @State var toAddDoneView = false
    @State var isAddData: Bool = false
    
    // 외부에서 바인딩된 이미지와 녹음 파일 변수
    @Binding var selectedImage: UIImage?
    @Binding var recording: URL?
    
    // 뷰 본문
    var body: some View {
        NavigationStack {
            VStack{
                // 선택된 이미지가 있으면 이미지를 표시, 없으면 'No image' 문구 표시
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
                
                // 정보 입력 리스트
                List {
                    // 제목 입력 필드
                    HStack{
                        Text("제목")
                        Spacer(minLength: 100)
                        TextField("제목", text: $title)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: title) { newValue in
                                // 제목은 20자로 제한
                                title = String(newValue.prefix(20))
                            }
                    }
                    .listRowBackground(Color("JoyWhite"))
                    
                    // 태그 선택 뷰로 이동
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
                    
                    // 날짜 선택 피커
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
            // 뒤로가기 버튼 숨기기
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // 'Done' 버튼: 데이터 추가 후 AddDoneView로 이동
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
                                                    
                                                    // Realm 데이터베이스에 메모리 추가
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
                    // 제목이 비어 있으면 'Done' 버튼 비활성화
                    .disabled(title == "")
                }
            }
            .tint(Color("JoyBlue"))
        }
    }
}
