//
//  EditView.swift
//  WatanabeDesign
//
//  Created by 渡辺幹 on 2022/07/28.
//

import SwiftUI

struct EditView: View {
    @StateObject var model: LayoutModel
    @Binding var status: ShapeConfiguration
    @State var isSelectFont = false
    @State var isSelectSymbol = false
    @State var changeColor = "main"
    @State var isFrameColorEdit = false
    @State var isShadowColorEdit = false
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            ShapeView(status: $status)
                .position(status.position)
            
            Button(action: {return}){
                Rectangle()
                    .frame(width: status.size.width,
                           height: status.size.height)
                    .position(status.position)
                    .opacity(0.0)
            }
            
            VStack {
                Button(action: {
                    model.editMode(isMove: false)
                    dismiss()
                }){
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 40)
                        .overlay(
                            Text("CLOSE")
                            .font(.title2)
                            .foregroundColor(Color.white))
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                ZStack {
                    editButtons.frame(width: phone.w, height: phone.h/2)
                    if isSelectFont {fontListView(status: $status)}
                    if isSelectSymbol {SFSymbolsList(status: $status)}
                }
            }
            
            // fontList表示ボタン
            HStack {
                Spacer().frame(width: phone.w*0.85)
                VStack {
                    Button(action: {
                        isSelectFont.toggle()
                    }){
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: phone.w/10, height: phone.w/10)
                            .foregroundColor(Color.white)
                            .overlay(
                                Image(systemName: "f.square")
                                    .resizable()
                                    .frame(width: phone.w/10, height: phone.w/10)
                                    .foregroundColor(Color.black)
                            )
                    }
                    Button(action: {
                        isSelectSymbol.toggle()
                    }){
                        Image("iconImage")
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                    }
                }
            }
        }.background(Color.white)
    }
    
    var editButtons: some View {
        // 設定ボタンリスト
            ScrollView {
                Spacer().frame(width: phone.w*0.85)
                Group {
                    selectStyleView(status: $status)
                    selectColoriew(status: $status, changeStatus: "")
                    editSizeView(status: $status)
                    editCornerView(status: $status)
                    editTextView(status: $status)
                }
                Group {
                    editFrameView(status: $status, isColorEdit: $isFrameColorEdit)
                    if isFrameColorEdit{selectColoriew(status: $status, changeStatus: "フレーム")}
                    editShadowView(status: $status, isColorEdit: $isShadowColorEdit)
                    if isShadowColorEdit{selectColoriew(status: $status, changeStatus: "シャドウ")}
                    editRotationView(status: $status)
                }
                
            }
            .frame(width: phone.w*0.85)
            .padding(.trailing, phone.w*0.15)
            .border(Color.gray)
        
    }
    
}

struct selectStyleView: View {
    @Binding var status: ShapeConfiguration
    let StyleList = ["Rectangle", "Circle", "Ellipse", "Text", "SFSymbols"]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: phone.w*0.8, height: phone.w*0.2)
                .foregroundColor(Color.white)
                .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                .overlay(
                    Text("スタイル").font(.custom("Times New Roman", size: 10))
                        .frame(width: phone.w*0.8, height: phone.w*0.2,
                               alignment: .topLeading)
                )
            HStack(spacing: 5) {
                ForEach(StyleList, id: \.self){ style in
                    Button(action: {
                        status.style = style
                    }) {
                        editViewStyleButtons(style: style)
                    }
                }
            }
        }
    }
}

struct selectColoriew: View {
    @Binding var status: ShapeConfiguration
    let changeStatus: String
    let ColorList: [Color] = [.red, .pink, .orange, .yellow, .purple,
                              .blue, .green, .black, .gray, .white, .clear]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: phone.w*0.8, height: phone.w*0.3)
                .foregroundColor(Color.white)
                .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                .overlay(
                    Text(changeStatus + "カラー").font(.custom("Times New Roman", size: 10))
                        .frame(width: phone.w*0.8, height: phone.w*0.3, alignment: .topLeading)
                )
            VStack {
                colorButtons
                colorButtons
            }
        }
    }
    var colorButtons: some View {
        ScrollView(.horizontal){
            HStack(spacing: 2) {
                ForEach(ColorList, id: \.self){ color in
                    Button(action: {
                        if changeStatus == "フレーム" {
                            status.frame.frameColor = color
                        } else if changeStatus == "シャドウ" {
                            status.shadow.shadowColor = color
                        } else {
                            status.color = color
                        }
                    }){
                        Rectangle()
                            .stroke(lineWidth: 1)
                            .frame(width: phone.w/10 + 1, height: phone.w/10 + 1)
                            .foregroundColor(Color.gray)
                            .overlay(
                                Rectangle()
                                    .frame(width: 1, height: phone.w/8)
                                    .foregroundColor(color == .clear ? Color.black : color)
                                    .rotationEffect(Angle(degrees: 45))
                            )
                            .overlay(
                                Rectangle()
                                    .frame(width: phone.w/10, height: phone.w/10)
                                    .foregroundColor(color)
                            )
                    }
                }
            }
        }.frame(width: phone.w*0.75)
    }
}

struct editSizeView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: phone.w*0.8, height: phone.w*0.3)
                .foregroundColor(Color.white)
                .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                .overlay(
                    Text("サイズ").font(.custom("Times New Roman", size: 10))
                        .frame(width: phone.w*0.8, height: phone.w*0.3, alignment: .topLeading)
                )
            VStack(spacing: 0) {
                HStack {
                    Text("W: \(String(format: "%.0f", status.size.width))")
                        .frame(width: 70, alignment: .leading)
                    
                    Image(systemName: "minus.rectangle")
                        .resizable()
                        .frame(width: phone.w/20, height: phone.w/20)
                        .onTapGesture { status.size.width-=1 }
                    
                    Slider(value: $status.size.width, in: 1...phone.w*1.1)
                        .frame(width: phone.w*0.4)
                    
                    Image(systemName: "plus.rectangle")
                        .resizable()
                        .frame(width: phone.w/20, height: phone.w/20)
                        .onTapGesture { status.size.width+=1 }
                }
                Button(action: {
                    
                }){
                    Image(systemName: "lock.open") //lock .frame(width: 10, height: 15)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.black)
                        .padding(.trailing, phone.w*0.6)
                }
                HStack {
                    Text("H: \(String(format: "%.0f", status.size.height))")
                        .frame(width: 70, alignment: .leading)
                    
                    Image(systemName: "minus.rectangle")
                        .resizable()
                        .frame(width: phone.w/20, height: phone.w/20)
                        .onTapGesture { status.size.height-=1 }
                    
                    Slider(value: $status.size.height, in: 1...phone.h*1.1)
                        .frame(width: phone.w*0.4)
                    
                    Image(systemName: "plus.rectangle")
                        .resizable()
                        .frame(width: phone.w/20, height: phone.w/20)
                        .onTapGesture { status.size.height+=1 }
                }
            }
        }
    }
}

struct editCornerView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        if status.style == "Rectangle" {
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: phone.w*0.8, height: phone.w*0.15)
                    .foregroundColor(Color.white)
                    .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                    .overlay(
                        Text("コーナー").font(.custom("Times New Roman", size: 10))
                            .frame(width: phone.w*0.8, height: phone.w*0.15, alignment: .topLeading)
                    )
                HStack {
                    Text("丸さ: \(String(format: "%.0f", status.corner))")
                        .frame(width: 70, alignment: .leading)
                    
                    Image(systemName: "minus.rectangle")
                        .resizable()
                        .frame(width: phone.w/20, height: phone.w/20)
                        .onTapGesture { status.corner-=1 }

                    Slider(value: $status.corner, in: 1...50)
                                            .frame(width: phone.w*0.4)

                    Image(systemName: "plus.rectangle")
                        .resizable()
                        .frame(width: phone.w/20, height: phone.w/20)
                        .onTapGesture { status.corner+=1 }
                }
            }
        }
    }
}

struct editTextView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        if status.style == "Text" {
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: phone.w*0.8, height: phone.w*0.3)
                    .foregroundColor(Color.white)
                    .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                    .overlay(
                        Text("テキスト").font(.custom("Times New Roman", size: 10))
                            .frame(width: phone.w*0.8, height: phone.w*0.3, alignment: .topLeading)
                    )
                VStack {
                    HStack {
                        TextField("テキストを入力", text: $status.text.character)
                            .frame(width: phone.w*0.75, height: 30)
                            .border(Color.gray)
                    }
                    HStack {
                        Text("サイズ: \(String(format: "%.0f", status.text.size))")
                        .frame(width: 80, alignment: .leading)

                        Image(systemName: "minus.rectangle")
                            .resizable()
                            .frame(width: phone.w/20, height: phone.w/20)
                            .onTapGesture { status.text.size-=1 }

                        Slider(value: $status.text.size, in: 1...99)
                                                .frame(width: phone.w*0.2)

                        Image(systemName: "plus.rectangle")
                            .resizable()
                            .frame(width: phone.w/20, height: phone.w/20)
                            .onTapGesture { status.text.size+=1 }
                        
                        Button(action: {}){
                            Image(systemName: "f.square")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.leading, 10)
                        }
                    }
                }
            }
        }
    }
}

struct editFrameView: View {
    @Binding var status: ShapeConfiguration
    @Binding var isColorEdit: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: phone.w*0.8, height: phone.w*0.25)
                .foregroundColor(Color.white)
                .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                .overlay(
                    Text("フレーム").font(.custom("Times New Roman", size: 10))
                        .frame(width: phone.w*0.8, height: phone.w*0.25, alignment: .topLeading)
                )
            HStack {
                Group {
                    VStack {
                        HStack {
                            Text("幅 ")

                            Image(systemName: "minus.rectangle")
                                .resizable()
                                .frame(width: phone.w/20, height: phone.w/20)
                                .onTapGesture { status.frame.frameWidth-=1 }

                            Text("\(String(format: "%.0f", status.frame.frameWidth))")
                                .frame(width: 30, alignment: .center)

                            Image(systemName: "plus.rectangle")
                                .resizable()
                                .frame(width: phone.w/20, height: phone.w/20)
                                .onTapGesture { status.frame.frameWidth+=1 }
                        }
                        Text("色の変更")
                            .background(Color.gray)
                            .onTapGesture { isColorEdit.toggle() }
                    }
                }
                Group {
                    Text("透明度 ")

                    Image(systemName: "minus.rectangle")
                        .resizable()
                        .frame(width: phone.w/20, height: phone.w/20)
                        .onTapGesture { status.frame.frameOpacity-=0.1 }

                    Text("\(String(format: "%.1f", status.frame.frameOpacity))")
                        .frame(width: 30, alignment: .center)

                    Image(systemName: "plus.rectangle")
                        .resizable()
                        .frame(width: phone.w/20, height: phone.w/20)
                        .onTapGesture { status.frame.frameOpacity+=0.1 }
                }
            }
        }
    }
}

struct editShadowView: View {
    @Binding var status: ShapeConfiguration
    @Binding var isColorEdit: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: phone.w*0.8, height: phone.w*0.25)
                .foregroundColor(Color.white)
                .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                .overlay(
                    Text("シャドウ").font(.custom("Times New Roman", size: 10))
                        .frame(width: phone.w*0.8, height: phone.w*0.25, alignment: .topLeading)
                )
            HStack {
                VStack {
                    HStack {
                        Text("ぼかし ")

                        Image(systemName: "minus.rectangle")
                            .resizable()
                            .frame(width: phone.w/20, height: phone.w/20)
                            .onTapGesture { status.shadow.shadowRadius-=1 }

                        Text("\(String(format: "%.0f", status.shadow.shadowRadius))")
                            .frame(width: 30, alignment: .center)

                        Image(systemName: "plus.rectangle")
                            .resizable()
                            .frame(width: phone.w/20, height: phone.w/20)
                            .onTapGesture { status.shadow.shadowRadius+=1 }
                    }
                    Text("色の変更")
                        .background(Color.gray)
                        .onTapGesture { isColorEdit.toggle() }
                }
                Spacer().frame(width: phone.w/15)
                VStack {
                    Group {
                        HStack {
                            Text("X ")

                            Image(systemName: "minus.rectangle")
                                .resizable()
                                .frame(width: phone.w/20, height: phone.w/20)
                                .onTapGesture { status.shadow.shadow_x-=1 }

                            Text("\(String(format: "%.0f", status.shadow.shadow_x))")
                                .frame(width: 30, alignment: .center)

                            Image(systemName: "plus.rectangle")
                                .resizable()
                                .frame(width: phone.w/20, height: phone.w/20)
                                .onTapGesture { status.shadow.shadow_x+=1 }
                        }
                        HStack{
                            Text("Y ")

                            Image(systemName: "minus.rectangle")
                                .resizable()
                                .frame(width: phone.w/20, height: phone.w/20)
                                .onTapGesture { status.shadow.shadow_y-=1 }

                            Text("\(String(format: "%.0f", status.shadow.shadow_y))")
                                .frame(width: 30, alignment: .center)

                            Image(systemName: "plus.rectangle")
                                .resizable()
                                .frame(width: phone.w/20, height: phone.w/20)
                                .onTapGesture { status.shadow.shadow_y+=1 }
                        }
                    }
                }
            }
        }
    }
}

struct editRotationView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: phone.w*0.8, height: phone.w*0.3)
                .foregroundColor(Color.white)
                .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                .overlay(
                    Text("ローテーション").font(.custom("Times New Roman", size: 10))
                        .frame(width: phone.w*0.8, height: phone.w*0.3, alignment: .topLeading)
                )
        }
    }
}

struct fontListView: View {
    @Binding var status: ShapeConfiguration
    var names: [String] = UIFont.familyNames
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: phone.w*0.8, height: phone.h/2)
                .foregroundColor(Color.gray)
                .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
            VStack {
                ScrollView {
                    VStack(spacing: 3){
                        ForEach(names, id: \.self){ name in
                            Text("テキスト : \(name)")
                                .font(.custom(name, size: 15))
                                .frame(width: phone.w*0.65, height: 20,
                                       alignment: .leading)
                                .padding()
                                .background(Color.white)
                                .border(Color.black)
                                .onTapGesture { status.text.font = name }
                        }
                    }
                }.frame(height: phone.h*0.45)
            }
        }.frame(width: phone.w*0.85, height: phone.h/2)
            .padding(.trailing, phone.w*0.15)
    }
}

struct editViewStyleButtons: View {
    @State var style: String
    var body: some View {
        Group{
            if style == "Rectangle" {
                RoundedRectangle(cornerRadius: 0)
                    .frame(width: phone.w/10, height: phone.w/10)
            } else if style == "Circle" {
                Capsule()
                    .frame(width: phone.w/9, height: phone.w/9)
            } else if style == "Ellipse" {
                Ellipse()
                    .frame(width: phone.w/9, height: phone.w/12)
            } else if style == "Text" {
                Image(systemName: "t.square")
                    .resizable()
                    .frame(width: phone.w/10, height: phone.w/10)
            } else if style == "SFSymbols" {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 3)
                    .frame(width: phone.w/10, height: phone.w/10)
                    .overlay(
                        Text("SF")
                            .font(.custom("default", size: phone.w/20))
                    )
            }
        }.foregroundColor(Color.black)
    }
}
