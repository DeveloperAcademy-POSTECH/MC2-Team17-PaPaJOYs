//
//  ImagePicker.swift
//  ForJOY
//
//  Created by hyebin on 2023/07/02.
//

import SwiftUI

// SwiftUI에서 UIKit의 UIImagePickerController를 사용하기 위한 래퍼 구조체
struct ImagePicker: UIViewControllerRepresentable {
     // 선택된 이미지를 바인딩하기 위한 변수
     @Binding var selectedImage: UIImage?
     
     // 이미지 선택의 출처 타입 (기본값은 .photoLibrary, 즉, 사진 라이브러리)
     var sourceType: UIImagePickerController.SourceType = .photoLibrary

     // Coordinator를 생성하는 함수
     func makeCoordinator() -> Coordinator {
         Coordinator(parent: self)
     }

     // UIViewControllerRepresentable 프로토콜을 준수하기 위한 함수
     // UIImagePickerController 인스턴스를 생성하고 설정하는 함수
     func makeUIViewController(context: Context) -> UIImagePickerController {
         let imagePickerController = UIImagePickerController()
         // 대리자를 Coordinator로 설정
         imagePickerController.delegate = context.coordinator
         // 이미지 소스 타입 설정
         imagePickerController.sourceType = sourceType
         return imagePickerController
     }

     // UIViewControllerRepresentable 프로토콜을 준수하기 위한 함수
     // SwiftUI에서 뷰 업데이트 시 호출되지만, 여기서는 구현이 필요 없음
     func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

     // UIImagePickerController의 대리자를 처리하기 위한 Coordinator 클래스
     class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
         // ImagePicker 인스턴스에 대한 참조
         let parent: ImagePicker

         // 초기화 함수
         init(parent: ImagePicker) {
             self.parent = parent
         }

         // 이미지를 선택했을 때 호출되는 함수
         func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
             // 선택한 이미지를 가져와서 parent의 selectedImage에 할당
             if let selectedImage = info[.originalImage] as? UIImage {
                 parent.selectedImage = selectedImage
             }
             // 이미지 피커 컨트롤러 닫기
             picker.dismiss(animated: true, completion: nil)
         }
     }
 }

