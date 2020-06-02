//
//  ContentView.swift
//  Learn
//
//  Created by 王智刚 on 2020/2/29.
//  Copyright © 2020 王智刚. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let scale: CGFloat = UIScreen.main.bounds.width / 414
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("0")
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24)
                .lineLimit(1)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            CalButtonPad()
                .padding(.bottom)
        }
        .scaleEffect(scale)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView().previewDevice("iPhone SE").environment(\.colorScheme, .dark)
        }
    }
}

struct CalButtonPad: View {
    let pad: [[CalButtonItem]] = [
        [.command(.clear), .command(.flip), .command(.percent), .op(.divide)],
        [.digit(7), .digit(8), .digit(9), .op(.multiply)],
        [.digit(4), .digit(5), .digit(6), .op(.minus)],
        [.digit(1), .digit(2), .digit(3), .op(.plus)],
        [.digit(0), .dot, .op(.equal)]
    ]
    var body: some View {
        VStack(spacing: 8) {
            ForEach(pad, id: \.self) { row in
                CalButtonRow(row: row)
            }
        }
    }
}

struct CalButtonRow: View {
    let row: [CalButtonItem]
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalButton2(size: item.size, title: item.title,  bgColorName: item.bgColorName)
                {
                    print("button \(item.title) click")
                }
            }
        }
    }
}

struct CalButton: View {
    let fontSize: CGFloat = 38
    let size: CGSize
    let title: String
    let bgColorName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: fontSize))
                .frame(width: size.width, height: size.height, alignment: Alignment.center)
                .background(Color(bgColorName))
                .cornerRadius(size.width / 2)
        }
    }
}

struct CalButton2: View {
    let fontSize: CGFloat = 38
    let size: CGSize
    let title: String
    let bgColorName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .frame(width: size.width, height: size.height)
                    .foregroundColor(Color(bgColorName))
                    .cornerRadius(size.width / 2)
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: fontSize))
                    .background(Color.clear)
            }
        }
    }
}

struct CalButtonRow2: View {
    let row: [CalButtonItem]
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalButton(size: item.size, title: item.title,  bgColorName: item.bgColorName)
                {
                    print("button \(item.title) click")
                }
            }
        }
    }
}

