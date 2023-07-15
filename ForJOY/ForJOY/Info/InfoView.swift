//
//  InfoView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/09.
//

import SwiftUI

struct InfoView: View {
    @EnvironmentObject var voiceViewModel: VoiceViewModel
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
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
                GeometryReader { geometry in
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width - 30, height: geometry.size.height)
                        .clipped()
                        .cornerRadius(10)
                        .padding(.horizontal, 15)
                        .padding(.top, 25)
                }
                
                List {
                    HStack{
                        Text("제목")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("제목", text: $title)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: title) { newValue in
                                title = String(newValue.prefix(20))
                            }
                    }
                    .listRowBackground(Color("JoyWhite"))
                    
                    HStack(){
                        Text("태그")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        NavigationLink(destination: InfoTagView(selectTag: $tag), label: {
                            if tag == nil {
                                Text("없음")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            } else {
                                Text(tag!)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
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
                                        .environment(\.managedObjectContext, viewContext)
                                        .navigationBarBackButtonHidden()
                                        .onAppear() {
                                            if !isAddData {
                                                if title != "" {
                                                    let year = Int(date.toString(dateFormat: "yyyy"))!
                                                    
                                                    addMemory(title, Int16(year), date, tag ?? "기본", selectedImage!.jpegData(compressionQuality: 0.8)!.base64EncodedString(), recording!.absoluteString)
                                                    
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
            .gesture(DragGesture(minimumDistance: 3.0,
                                 coordinateSpace: .local)
                .onEnded({ (value) in
                    if value.translation.width > 0 {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }))
        }
    }
    
    func addMemory(_ title: String, _ year: Int16, _ date: Date, _ tag: String, _ image: String, _ voice: String) {
        let memory = Memories(context: viewContext)
        
        memory.title = title
        memory.year = year
        memory.date = date
        memory.tag = tag
        memory.image = image
        memory.voice = voice
        
        saveContext()
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}
