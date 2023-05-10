//
//  InfoTagView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/09.
//

import SwiftUI

struct Tag: Identifiable {
    var id = UUID()
    var tag: String
}

struct InfoTagView: View {
    @State var addTag: Bool = false
    @State var newTag: String = ""
    @Binding var tag: String?
    
    @State var tags = [
       Tag(tag: "이서"),
       Tag(tag: "이한")
     ]
    
    var body: some View {
        NavigationView(){
            VStack{
                List(selection: $tag){
                    ForEach(tags) { t in
                        if t.tag == tag {
                            HStack {
                                Text(t.tag)
                                    .tag(t.tag)
                                Spacer(minLength: 220)
                                Image(systemName: "checkmark")
                            }
                            .listRowBackground(Color("JoyWhite"))
                        }else{
                            Text(t.tag)
                                .tag(t.tag)
                                .listRowBackground(Color("JoyWhite"))
                        }
                    }
                    
                    if addTag{
                        TextField("테그", text: $newTag, onCommit: {addNewTag()})
                            .listRowBackground(Color("JoyWhite"))
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color("JoyDarkG"))
                
                Button(action: {
                    addTag = true
                }, label: {
                    Text("Add tag")
                })
                
            }
            .padding(8)
            .background(Color("JoyDarkG"))
        }
        .navigationTitle("Tag")
        
    }
    
    func addNewTag() {
        addTag  = false
        if newTag != "" {
            tags.append(Tag(tag: newTag))
            DispatchQueue.main.async {
                self.newTag = ""
            }
        }
    }
}

struct InfoTagView_Previews: PreviewProvider {
    static var previews: some View {
        InfoTagView(tag: .constant("nil"))
    }
}
