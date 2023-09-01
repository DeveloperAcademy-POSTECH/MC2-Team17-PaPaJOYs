//
//  InfoTagView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/09.
//

import SwiftUI

struct InfoTagView: View {
    @State private var addTag: Bool = false
    @State private var newTag: String = ""
    @State private var tags = [Tag]()
    @State private var isValueSet: Bool = false
    
    @Binding var selectTag: String?
    @Binding var showTagView: Bool
    
    var body: some View {
        NavigationStack{
            VStack{
                List(selection: $selectTag){
                    ForEach(0...min(tags.count, 9), id: \.self) { index in
                        if tags.count < 10 && index == tags.count {
                            HStack {
                                TextField("새로운 태그", text: $newTag)
                                    .onChange(of: newTag) { newValue in
                                        newTag = String(newValue.prefix(20))
                                    }
                                    .onSubmit {
                                        if !tags.contains(where: {$0.tagName == newTag}){
                                            tags.append(Tag(tagName: newTag))
                                        }
                                        newTag = ""
                                    }
                                
                                Spacer(minLength: 0)
                                
                                Button(
                                    action: {newTag = ""},
                                    label: {
                                        Image(systemName: "x.circle.fill")
                                            .font(Font.system(size: 16, weight: .semibold))
                                            .foregroundColor(.gray.opacity(0.5))
                                    }
                                )
                            }
                            .listRowBackground(Color.joyWhite)
                        }
                        else {
                            Button(
                                action: {
                                    selectTag = (selectTag == tags[index].tagName) ? nil : tags[index].tagName
                                }, label: {
                                    HStack {
                                        Text(tags[index].tagName)
                                            .tag(tags[index].tagName)
                                            .foregroundColor(Color.black)
                                        
                                        Spacer(minLength: 0)
                                        
                                        if tags[index].tagName == selectTag {
                                            Image(systemName: "checkmark")
                                                .multilineTextAlignment(.trailing)
                                                .font(Font.system(size: 17, weight: .semibold))
                                                .foregroundColor(Color.joyBlue)
                                        }
                                    }
                                }
                            )
                            .listRowBackground(Color.joyWhite)
                        }
                    }
                    .onDelete{ index in
                        tags.remove(atOffsets: index)
                        saveTags()
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding(8)
            .background(Color.joyDarkG)
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
                }
                
                if let selectTag = selectTag, !tags.contains(where: { $0.tagName == selectTag }) {
                    tags.append(Tag(tagName: selectTag))
                }
            }
            .navigationTitle("태그")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.joyDarkG)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {showTagView.toggle()},
                        label: {
                            Image(systemName: "x.circle.fill")
                                .font(Font.system(size: 16, weight: .semibold))
                                .foregroundColor(.gray)
                        })
                }
            }
        }
        .tint(Color.joyBlue)
    }
    
    func saveTags() {
        if let data = try? JSONEncoder().encode(tags) {
            UserDefaults.standard.set(data, forKey: "tags")
        }
    }
}
