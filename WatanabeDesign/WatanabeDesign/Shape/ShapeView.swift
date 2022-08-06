//
//  ShapeView.swift
//  WatanabeDesign
//
//  Created by 渡辺幹 on 2022/07/28.
//

import SwiftUI

struct ShapeView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        // 縁の描画
        Shape(status: $status)
            .foregroundColor(status.frame.frameColor)
        .frame(width: status.size.width + status.frame.frameWidth + status.frame.frameWidth,
               height: status.size.height + status.frame.frameWidth + status.frame.frameWidth)
        .opacity(status.frame.frameOpacity)
        .shadow(color: status.shadow.shadowColor,
                radius: status.shadow.shadowRadius,
                x: status.shadow.shadow_x,
                y: status.shadow.shadow_y)
        .overlay(
            // 図の描画
            Shape(status: $status)
                .frame(width: status.size.width, height: status.size.height)
                .foregroundColor(status.color)
                .opacity(status.opacity)
        )
        .rotationEffect(status.rotation)
        
        .position(status.position)
        .gesture(DragGesture()
            .onChanged({ value in
                if !status.lock { self.status.position = value.location }})
        )
        
    }
}

struct Shape: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        if status.style == "Rectangle" {
            RectangleView(status: $status)
        } else if status.style == "Circle" {
            CircleView(status: $status)
        } else if status.style == "Ellipse" {
            ElipseView(status: $status)
        } else if status.style == "Text" {
            TextView(status: $status)
        } else if status.style == "SFSymbols" {
            SymbolView(status: $status)
        }
    }
}

struct RectangleView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        RoundedRectangle(cornerRadius: status.corner)
    }
}

struct CircleView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        Capsule()
    }
}

struct ElipseView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        Ellipse()
    }
}

struct TextView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        Text(status.text.character == "" ?
             "テキスト" : "\(status.text.character)")
        .font(.custom(status.text.font, size: status.text.size))
    }
}

struct SymbolView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        Image(systemName: status.symbolName)
            .resizable()
    }
}

// 図の構造 構成=configuration
struct ShapeConfiguration: Identifiable {
    var id = UUID().uuidString
    var style: String
    var color: Color
    var size: CGSize
    var position: CGPoint
    var opacity: Double
    var rotation: Angle
    var shadow: ShadowConfiguration
    var frame: FrameConfiguration
    
    var lock: Bool
    var corner: CGFloat
    var symbolName: String
    var text: TextConfiguration
}


// シャドウ
struct ShadowConfiguration {
    var shadowColor: Color
    var shadowRadius: CGFloat
    var shadow_x: CGFloat
    var shadow_y: CGFloat
}

// フチ
struct FrameConfiguration {
    var frameWidth: CGFloat
    var frameColor: Color
    var frameOpacity: Double
}


// 文字
struct TextConfiguration {
    var character: String
    var font: String
    var size: CGFloat
}
