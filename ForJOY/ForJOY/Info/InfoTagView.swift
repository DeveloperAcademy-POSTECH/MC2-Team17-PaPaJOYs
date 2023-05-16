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
    @Binding var selectTag: String?
    @State private var tags = [Tag]()
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
                                Spacer(minLength: 220)
                                Image(systemName: "checkmark")
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
        addTag  = false
    }
    
    func saveTags() {
        if let data = try? JSONEncoder().encode(tags) {
            UserDefaults.standard.set(data, forKey: "tags")
        }
    }

}
