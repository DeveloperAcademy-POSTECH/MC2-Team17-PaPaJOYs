//
//  RecAnimationView.swift
//  ForJOY
//
//  Created by Sehui Oh on 2023/05/04.
//

import SwiftUI

struct RecAnimationView: View {
    
    private enum AnimationProperties {
            static let animationSpeed: Double = 4
            static let timerDuration: TimeInterval = 3
            static let blurRadius: CGFloat = 20
        }
        
        @State private var timer = Timer.publish(every: AnimationProperties.timerDuration, on: .main, in: .common).autoconnect()
        @ObservedObject private var animator = CircleAnimator(colors: AuroraColors.all)
    @State private var isRecEnd = false
    
    
    var body: some View {
        
        ZStack{
            ZStack {
                ZStack {
                    ForEach(animator.circles) { circle in
                        //                            MovingCircle(originOffset: circle.position)
                        MovingCircle(originOffset: isRecEnd ? CGPoint(x: 0.5, y: 0.5) : circle.position)
                            .foregroundColor(circle.color)
                    }
                }.blur(radius: AnimationProperties.blurRadius)
                
            }
            .background(AuroraColors.backgroundColor)
            .onDisappear {
                timer.upstream.connect().cancel()
            }
            .onAppear {
                animateCircles()
                timer = Timer.publish(every: AnimationProperties.timerDuration, on: .main, in: .common).autoconnect()
            }
            .onReceive(timer) { _ in
                if isRecEnd {
                    timer.upstream.connect().cancel()
                }
                animateCircles()
            }
        
            Button("RecEnd") {
                isRecEnd.toggle()
            }
            
        }
            }
            
            private func animateCircles() {
                withAnimation(.easeInOut(duration: AnimationProperties.animationSpeed)) {
                    animator.animate()
                }
                if animator.circles.allSatisfy({ $0.position == CGPoint(x: 0.5, y: 0.5) }) {
                    isRecEnd = true
                }
            }
            
        }

        private enum AuroraColors {
            static var all: [Color] {
                [
                    Color("JoyBlue"),
                    Color("JoyYellow"),
                ]
            }
            
            static var backgroundColor: Color {
                Color("JoyDarkG")
            }
        }

        private struct MovingCircle: Shape {
            
            var originOffset: CGPoint
            
            var animatableData: CGPoint.AnimatableData {
                get {
                    originOffset.animatableData
                }
                set {
                    originOffset.animatableData = newValue
                }
            }
            
            func path(in rect: CGRect) -> Path {
                var path = Path()
                
                let adjustedX = rect.width * originOffset.x
                let adjustedY = rect.height * originOffset.y
                let smallestDimension = min(rect.width, rect.height)
                path.addArc(center: CGPoint(x: adjustedX, y: adjustedY), radius: smallestDimension/2, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
                return path
            }
        }

        private class CircleAnimator: ObservableObject {
            class Circle: Identifiable {
                internal init(position: CGPoint, color: Color) {
                    self.position = position
                    self.color = color
                }
                var position: CGPoint
                let id = UUID().uuidString
                let color: Color
            }
            
            @Published private(set) var circles: [Circle] = []
            
            
            init(colors: [Color]) {
                circles = colors.map({ color in
                    Circle(position: CircleAnimator.generateRandomPosition(), color: color)
                })
            }
            
            func animate() {
                objectWillChange.send()
                for circle in circles {
                    circle.position = CircleAnimator.generateRandomPosition()
                }
            }
            
            static func generateRandomPosition() -> CGPoint {
                CGPoint(x: CGFloat.random(in: 0 ... 1), y: CGFloat.random(in: 0 ... 1))
        

        
        
    }
}

struct RecAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        RecAnimationView()
    }
}
