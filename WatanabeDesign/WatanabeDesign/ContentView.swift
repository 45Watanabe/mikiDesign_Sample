//
//  ContentView.swift
//  WatanabeDesign
//
//  Created by 渡辺幹 on 2022/07/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LayoutView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct phone {
    static let w = UIScreen.main.bounds.width
    static let h = UIScreen.main.bounds.height
}
