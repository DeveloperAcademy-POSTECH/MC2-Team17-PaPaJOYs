//
//  InfoTagView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/09.
//

import SwiftUI

// 사용자에게 태그 정보를 보여주고 추가/수정/삭제 기능을 제공하는 뷰
struct InfoTagView: View {
    @State var addTag: Bool = false           // 새 태그를 추가할지 여부
    @State var newTag: String = ""            // 새로운 태그 이름
    @State private var tags = [Tag]()         // 저장된 태그 목록
    @State private var isValueSet: Bool = false // UserDefaults에 값이 설정되었는지 여부
    @Binding var selectTag: String?           // 선택된 태그
    @FocusState private var textFieldIsFocused: Bool // 태그 입력 필드의 포커스 상태
    
    var body: some View {
        NavigationStack{
            VStack{
                // 저장된 태그 목록 및 새 태그 입력 필드 표시
                List(selection: $selectTag){
                    ForEach(tags) { t in
                        // 선택된 태그에 체크마크 이미지 추가
                        if t.tagName == selectTag {
                            HStack {
                                Text(t.tagName)
                                    .tag(t.tagName)
                                Spacer(minLength: 150)
                                Image(systemName: "checkmark")
                                    .multilineTextAlignment(.trailing)
                            }
                            .listRowBackground(Color("JoyWhite"))
                        }else{
                            Text(t.tagName)
                                .tag(t.tagName)
                                .listRowBackground(Color("JoyWhite"))
                        }
                    }
                    // 태그 삭제 기능
                    .onDelete{ index in
                        tags.remove(atOffsets: index)
                        saveTags()
                        if tags.isEmpty {
                            addTag = true
                            textFieldIsFocused = true
                        }
                    }
                    // 새 태그 입력 필드
                    if addTag{
                        TextField("태그", text: $newTag, onCommit: {addNewTag()})
                            .listRowBackground(Color("JoyWhite"))
                            .focused($textFieldIsFocused)
                    }
                }
                .scrollContentBackground(.hidden)
                // 새 태그 추가 버튼
                Button(action: {
                    addTag = true
                    textFieldIsFocused = true
                }, label: {
                    HStack{
                        Image(systemName: "plus.circle.fill")
                        Text("Add tag")
                    }
                    .foregroundColor(Color("JoyBlue"))
                })
            }
            .padding(8)
            .background(Color("JoyDarkG"))
            .foregroundColor(.black)
            // 뷰가 사라질 때 태그 저장
            .onDisappear() {
                saveTags()
            }
            // 뷰가 나타날 때 저장된 태그 불러오기 및 초기 태그 설정
            .onAppear(){
                tags = {
                    if let data = UserDefaults.standard.data(forKey: "tags"),
                       let tags = try? JSONDecoder().decode([Tag].self, from: data) {
                        return tags
                    }
                    return []
                }()
                isValueSet = UserDefaults.standard.bool(forKey: "IsValueSet")
                if isValueSet == false {
                    UserDefaults.standard.set(true, forKey: "IsValueSet")
                    tags.append(Tag(tagName: "우리 공주님"))
                    tags.append(Tag(tagName: "우리 왕자님"))
                    tags.append(Tag(tagName: "우리집"))
                }
                
                if tags.isEmpty {
                    addTag = true
                    textFieldIsFocused = true
                }
            }
        }
        .navigationTitle("Tag")
        .tint(Color("JoyBlue"))
    }
    
    // 새 태그 추가 함수
    func addNewTag() {
        if newTag != "" {
            textFieldIsFocused = true
            tags.append(Tag(tagName: newTag))
            DispatchQueue.main.async {
                self.newTag = ""
            }
        }
        selectTag = newTag
        addTag  = false
    }
    
    // 태그를 UserDefaults에 저장하는 함수
    func saveTags() {
        if let data = try? JSONEncoder().encode(tags) {
            UserDefaults.standard.set(data, forKey: "tags")
        }
    }
}
