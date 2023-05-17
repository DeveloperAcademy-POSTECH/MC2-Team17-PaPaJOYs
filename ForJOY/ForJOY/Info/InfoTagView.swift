//
//  InfoTagView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/09.
//

import SwiftUI

struct InfoTagView: View {
    @State var addTag: Bool = false
    @State var newTag: String = ""
    @State private var tags = [Tag]()
    @State private var isValueSet: Bool = false
    @Binding var selectTag: String?
    @FocusState private var textFieldIsFocused: Bool
    
    var body: some View {
        NavigationStack{
            VStack{
                List(selection: $selectTag){
                    ForEach(tags) { t in
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
                    .onDelete{ index in
                        tags.remove(atOffsets: index)
                        saveTags()
                        if tags.isEmpty {
                            addTag = true
                            textFieldIsFocused = true
                        }
                    }
            
                    if addTag{
                        TextField("태그", text: $newTag, onCommit: {addNewTag()})
                            .listRowBackground(Color("JoyWhite"))
                            .focused($textFieldIsFocused)
                    }
                }
                .scrollContentBackground(.hidden)
                
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
            .onDisappear() {
                saveTags()
            }
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
    
    func saveTags() {
        if let data = try? JSONEncoder().encode(tags) {
            UserDefaults.standard.set(data, forKey: "tags")
        }
    }

}
