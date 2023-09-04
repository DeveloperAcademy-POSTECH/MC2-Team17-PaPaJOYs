//
//  UINavigationController+.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/09/02.
//

import SwiftUI

// Swipe를 통한 네비게이션뷰 팝
extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
