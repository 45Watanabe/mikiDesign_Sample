//
//  LayoutView.swift
//  WatanabeDesign
//
//  Created by 渡辺幹 on 2022/07/28.
//

import SwiftUI

struct LayoutView: View {
    @StateObject private var model = LayoutModel()
    @State var isEditMode = false
    @State var ControlerPosition = CGPoint(x: 0, y: 0)
    var body: some View {
        ZStack {
            // 図の全表示
            ForEach($model.shapeArray){ status in
                ShapeView(status: status)
                    .onTapGesture {
                        model.select = model.searchArray(id: status.id) ?? 0
                    }
            }
            
            // 選択表示
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: model.selectedShape().size.width + 10,
                       height: model.selectedShape().size.height + 10)
                .foregroundColor(Color.red)
                .overlay(
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color.white)
                        .opacity(model.selectedShape().lock ?
                                 1.0 : 0.0)
                        .frame(alignment: .bottomTrailing)
                        .shadow(color: Color.black, radius: 10, x: 0, y: 0)
                )
                .position(model.selectedShape().position)
            
            ControllerView(model: model)
                .position(ControlerPosition)
                .animation(.default, value: model.isHide)
                
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 10)
                .frame(width: phone.w*0.5 + 5,
                       height: model.isHide ? 35 : phone.w*0.8 + 5)
                .animation(.default, value: model.isHide)
                .foregroundColor(Color.black)
                .opacity(0.05)
                .position(ControlerPosition)
                .gesture(DragGesture()
                    .onChanged({ value in
                        self.ControlerPosition = value.location}))
                .onAppear(){
                    ControlerPosition.x = UIScreen.main.bounds.width*0.75
                    ControlerPosition.y = UIScreen.main.bounds.width*0.4
                }
        }
    }
}

struct LayoutView_Previews: PreviewProvider {
    static var previews: some View {
        LayoutView()
    }
}
