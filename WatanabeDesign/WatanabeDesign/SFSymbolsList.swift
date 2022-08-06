//
//  SFSymbolsList.swift
//  WatanabeDesign
//
//  Created by 渡辺幹 on 2022/08/02.
//

import SwiftUI

struct SFSymbolsList: View {
    @Binding var status: ShapeConfiguration
    @State var allSymbols: [String] = []
    @State var symbolsSortedByName: [String] = []
    @State var searchWord = ""
    @State var selectSymbol = "applelogo"
    @State var isDispField = true
    private let layout = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width/6),
                                   alignment: .top)]
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    var body: some View {
        HStack(spacing: 0){
        ZStack {
            
            Rectangle()
                .foregroundColor(Color.white.opacity(0.95))
            
            ScrollView {
                Spacer().frame(height: 10)
                LazyVGrid(columns: layout, spacing: 3) {
                    ForEach(symbolsSortedByName, id: \.self){ name in
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: w*0.2, height: w*0.2)
                                .foregroundColor(selectSymbol == name ?
                                                 Color.gray.opacity(0.2) : Color.white)
                                .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                            
                            Button(action: { selectSymbol = name }){
                                Image(systemName: name)
                                    .renderingMode(.original)
                                    .imageScale(.large)
                                    .font(.system(size: w/15))
                                    .foregroundColor(Color.black)
                            }
                            
                            Text("\(name)")
                                .font(.custom("Times-Roman", size: 13))
                                .foregroundColor(Color.black)
                                .frame(width: w*0.2, height: w*0.2, alignment: .bottom)
                                .lineLimit(1)
                            
                        }
                         
                    }
                }.padding(5)
                Spacer().frame(height: w/3)
            }
            .frame(width: w*0.85, height: h/2)
            .border(Color.black)
            
            
            VStack {
                Spacer()
                selectStatus
                searchTab
            }.frame(width: w*0.85, height: h/2)
            
        }.frame(width: w*0.85, height: h/2)
//            .padding(.trailing, w*0.15)
            
            VStack {
                
            }.frame(width: w*0.14, height: h/2)
            
        }
        .onAppear(){
            allSymbols = symbolsFromFile(name: "allSymbols")
            symbolsSortedByName = symbolsFromFile(name: "allSymbols")
            print(symbolsSortedByName.count)
        }
    }
    private func symbolsFromFile(name: String) -> [String] {
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: "txt"),
              let fileContents = try? String(contentsOf: fileURL)
        else {
            print("aaaa")
            return []
        }
        return fileContents.split(separator: "\n").compactMap { $0.isEmpty ? nil : String($0) }
    }
    
    var selectStatus: some View {
        HStack {
            Text("\(selectSymbol)")
                .font(.custom("Times-Roman", size: 20))
                .foregroundColor(Color.black)
                .padding(5)
                .background(Color.white)
                .frame(width: w*0.7 + 5, alignment: .bottomTrailing)
                .lineLimit(1)
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.white)
                    .shadow(color: Color.black, radius: 10, x: 0, y: 0)
                
                Button(action: {}){
                    Image(systemName: "\(selectSymbol)")
                        .renderingMode(.original)
                        .imageScale(.large)
                        .font(.system(size: 20))
                        .foregroundColor(Color.black)
                }
            }
        }.frame(width: w*0.85, height: w/10, alignment: .leading)
    }
    
    var searchTab: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: isDispField ? w*0.7 + 5 : w*0.15,
                           height: 40)
                    .foregroundColor(Color.white)
                    .shadow(color: Color.black, radius: 10, x: 0, y: 0)
                    .animation(.default, value: isDispField)
                
                HStack {
                    Button(action: {}){
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: w/20, height: w/20)
                            .foregroundColor(Color.gray)
                            .shadow(color: Color.gray, radius: 10, x: 0, y: 0)
                            .animation(.default, value: isDispField)
                    }
                    Button(action: { isDispField.toggle() }){
                        Image(systemName: isDispField ? "chevron.right" : "chevron.left")
                            .resizable()
                            .frame(width: w/30, height: w/25)
                            .foregroundColor(Color.black)
                            .animation(.default, value: isDispField)
                    }
                    
                    if isDispField {
                        TextField("テキストを入力", text: $searchWord)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: w*0.55)
                            .onChange(of: searchWord){ newValue in
                                changeSearched(word: newValue)
                            }
                    }
                }
            }.padding(.leading, isDispField ? 0 : w*0.55 + 5)
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.white)
                    .shadow(color: Color.black, radius: 10, x: 0, y: 0)
                
                Button(action: { status.symbolName = selectSymbol }){
                    Image(systemName: "checkmark.square.fill")
                        .resizable()
                        .frame(width: w/15, height: w/15)
                }
            }
            
        }.frame(width: w*0.85, height: w/10, alignment: .leading)
            //.padding(.trailing, w*0.15)
             
    }
    
    func changeSearched(word: String) {
        if word == "" {
            symbolsSortedByName = allSymbols
        } else {
            symbolsSortedByName = []
        }
        for symbolName in allSymbols {
            if symbolName.contains(word.lowercased()) {
                symbolsSortedByName.append(symbolName)
            }
        }
    }
    
}
