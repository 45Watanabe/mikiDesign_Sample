//
//  ControllerView.swift
//  WatanabeDesign
//
//  Created by 渡辺幹 on 2022/07/28.
//

import SwiftUI

struct ControllerView: View {
    @StateObject var model: LayoutModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: phone.w*0.5 + 1,
                       height: model.isHide ? 31 : phone.w*0.8 + 1)
                .foregroundColor(Color.gray)
                .shadow(color: Color.black, radius: 2, x: 0, y: 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.white)
                        .frame(width: phone.w*0.5,
                               height: model.isHide ? 30 : phone.w*0.8)
                )
            
            VStack {
                HStack(spacing: 10) {
                    Group {
                        Button(action: {
                            model.isHide.toggle()
                        }){
                            Image(systemName: model.isHide ?
                                  "plus.square.fill" : "minus.square.fill")
                        }
                        Button(action: {
                            model.selectTabMode = "Home"
                            model.isHide = false
                        }){
                            Image(systemName: "house")//plus.square.on.square
                        }
                        Button(action: {
                            model.selectTabMode = "EditShape"
                            model.isHide = false
                        }){
                            Image(systemName: "wand.and.stars.inverse")
                        }
                        Button(action: {
                            model.selectTabMode = "RemovrShape"
                            model.isHide = false
                        }){
                            Image(systemName: "trash")
                        }
                        Button(action: {
                            model.selectTabMode = "MoveShape"
                            model.isHide = false
                        }){
                            Image(systemName: "circle.grid.cross")
                        }
                        Button(action: {
                            model.selectTabMode = "Setting"
                            model.isHide = false
                        }){
                            Image(systemName: "gear")
                        }
                    }.foregroundColor(Color.black)
                }
                if !model.isHide {
                    Spacer()
                    ControlTabView(model: model,
                                   status: $model.shapeArray[model.select],
                                   tabMode: $model.selectTabMode)
                    Spacer()
                }
            }.frame(width: phone.w*0.5,
                    height: model.isHide ? 30 : phone.w*0.8)
        }
    }
}

struct ControlTabView: View {
    @StateObject var model: LayoutModel
    @Binding var status: ShapeConfiguration
    @Binding var tabMode: String
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    var body: some View {
        if tabMode == "Home" {
            HomeTab(model: model)
        } else if tabMode == "EditShape" {
            EditShapeTab(model: model, status: $status)
        } else if tabMode == "MoveShape" {
            MoveShapeTab(model: model, status: $status)
        }
    }
}

struct HomeTab: View {
    @StateObject var model: LayoutModel
    
    let icons1 = ["plus.square","wand.and.rays","wand.and.stars"]
    let icons2 = ["trash.square","rectangle.on.rectangle.square","lock.square"]
    let icons3 = ["square.3.stack.3d.top.filled","square.2.stack.3d.top.filled",
                  "square.2.stack.3d.bottom.filled","square.3.stack.3d.bottom.filled"]
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                ForEach(icons1, id: \.self){ name in
                    Button(action: {
                        model.tapButtonInHomeTab(name: name)
                    }){
                        Image(systemName: name)
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                    }
                }
            }
            HStack(spacing: 15) {
                ForEach(icons2, id: \.self){ name in
                    Button(action: {
                        model.tapButtonInHomeTab(name: name)
                    }){
                        Image(systemName: name)
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                    }
                }
            }
            HStack {
                ForEach(icons3, id: \.self){ name in
                    Button(action: {
                        model.tapButtonInHomeTab(name: name)
                    }){
                        Image(systemName: name)
                            .resizable()
                            .frame(width: phone.w/13, height: phone.w/13)
                    }
                }
            }
            Image(systemName: "questionmark.circle")
                .onTapGesture { model.tapButtonInHomeTab(name: "questionmark.circle") }
                .frame(width: phone.w/2.2, alignment: .trailing)
                .fullScreenCover(isPresented: $model.isEditMode) {
                    EditView(model: model, status: $model.shapeArray[model.select])
                }
        }
    }
}

struct EditShapeTab: View {
    @StateObject var model: LayoutModel
    @Binding var status: ShapeConfiguration
    var body: some View {
        ZStack {
            editButtons
        }
    }
    var editButtons: some View {
        VStack {
            editStyle
            editColor
            editColor
            editSize
            ZStack {
                Spacer()
                    .frame(height: 35)
                if status.style == "Rectangle" {
                    editCorner
                } else if status.style == "Text" {
                    editText
                }
            }
            HStack {
                Button(action: { model.addShape() }){
                    Image(systemName: "plus.square")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                Button(action: { model.tapButtonInHomeTab(name: "wand.and.stars") }){
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: phone.w/3, height: 25)
                        .foregroundColor(Color.blue)
                        .overlay(Text("もっと細かく編集")
                            .font(.caption).foregroundColor(Color.white))
                        .fullScreenCover(isPresented: $model.isEditMode) {
                            EditView(model: model, status: $model.shapeArray[model.select])
                                .foregroundColor(Color.black)
                        }
                        
                }
            }
        }
    }
    
    let StyleList = ["Rectangle", "Circle", "Ellipse", "Text"]
    var editStyle: some View {
        HStack(spacing: 5) {
            ForEach(StyleList, id: \.self){ style in
                Button(action: {
                    status.style = style
                }) {
                    editStyleButtons(style: style)
                }
            }
        }
    }
    let ColorList: [Color] = [.red, .pink, .orange, .yellow, .purple,
                              .blue, .green, .black, .gray, .white]
    var editColor: some View {
        ScrollView(.horizontal){
            HStack(spacing: 2) {
                ForEach(ColorList, id: \.self){ color in
                    Button(action: {
                        status.color = color
                    }){
                        Rectangle()
                            .frame(width: phone.w/15, height: phone.w/15)
                            .foregroundColor(color)
                    }
                }
            }
        }.frame(width: phone.w/2.2)
    }
    var editSize: some View {
        VStack(spacing: 0) {
            Slider(value: $status.size.width, in: 1...phone.w*1.1)
                .frame(width: phone.w/2.2)
            Button(action: {
                
            }){
                Image(systemName: "lock.open") //lock .frame(width: 10, height: 15)
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color.black)
            }
            Slider(value: $status.size.height, in: 1...phone.h*1.1)
                .frame(width: phone.w/2.2)
        }
    }
    var editCorner: some View {
        HStack {
            Text("丸さ \(String(format: "%.0f", status.corner))")
                .foregroundColor(Color.black)
                .frame(width: phone.w/6, alignment: .leading)
            Slider(value: $status.corner, in: 0...99)
                .frame(width: phone.w/4)
        }
    }
    var editText: some View {
        TextField("テキストを入力", text: $status.text.character)
            .frame(width: phone.w/2.2, height: 30)
            .border(Color.gray)
    }
}

struct MoveShapeTab: View {
    @StateObject var model: LayoutModel
    @Binding var status: ShapeConfiguration
    @State var distance = 10
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("X : \(String(format: "%.1f", status.position.x))")
                        .frame(width: phone.w/4, alignment: .leading)
                    Text("Y : \(String(format: "%.1f", status.position.y))")
                        .frame(width: phone.w/4, alignment: .leading)
                }
                Spacer()
                VStack {
                    Button(action: {}){
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60, height: 20)
                            .overlay(Text("AUTO +")
                                .font(.caption)
                                .foregroundColor(Color.white))
                    }
                    HStack {
                        Button(action: {distance-=1}){
                            Text("-")
                        }
                        Text("\(distance)")
                            .frame(width: 25)
                        Button(action: {distance+=1}){
                            Text("+")
                        }
                    }
                }
            }
            VStack(spacing: 0){
                Button(action: {
                    model.moveShape(direction: "y-", distance: distance)
                }){
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                HStack {
                    Button(action: {
                        model.moveShape(direction: "x-", distance: distance)
                    }){
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    Spacer().frame(width: 50, height: 50)
                    Button(action: {
                        model.moveShape(direction: "x+", distance: distance)
                    }){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
                Button(action: {
                    model.moveShape(direction: "y+", distance: distance)
                }){
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            Text("端末").frame(width: phone.w/2.2, alignment: .leading)
            HStack {
                Text("横: \(String(format: "%.1f", phone.w)) x 縦: \(String(format: "%.1f", phone.h))")
            }
        }.frame(width: phone.w/2.2, height: 30)
    }
}

struct editStyleButtons: View {
    @State var style: String
    var body: some View {
        Group{
            if style == "Rectangle" {
                RoundedRectangle(cornerRadius: 0)
                    .frame(width: phone.w/13, height: phone.w/13)
            } else if style == "Circle" {
                Capsule()
                    .frame(width: phone.w/12, height: phone.w/12)
            } else if style == "Ellipse" {
                Ellipse()
                    .frame(width: phone.w/12, height: phone.w/14)
            } else if style == "Text" {
                Image(systemName: "t.square")
                    .resizable()
                    .frame(width: phone.w/14, height: phone.w/14)
            }
        }.foregroundColor(Color.black)
    }
}
