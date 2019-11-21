//
//  ViewController.swift
//  MYPLayout
//
//  Created by 王智刚 on 2018/12/10.
//  Copyright © 2018 王智刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = flight.layout
        
        let container = MYPLayoutContainer(layout)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .blue
        
        view.addSubview(container)
        view.addConstraints([
            container.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            ])
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension UILabel {
    convenience init(text: String, size: UIFont.TextStyle, multiline: Bool = false, textColor: UIColor = .black) {
        self.init()
        font = UIFont.preferredFont(forTextStyle: size)
        self.text = text
        self.textColor = textColor
        adjustsFontForContentSizeCategory = true
        if multiline {
            numberOfLines = 0
        }
    }
}

extension UIView {
    convenience init(backgroundColor: UIColor, cornerRadius: CGFloat = 0) {
        self.init()
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
    }
}

struct Airport {
    var city: String
    var code: String
    var time: Date
}

struct Flight {
    var origin: Airport
    var destination: Airport
    var name: String
    var terminal: String
    var gate: String
    var boarding: Date
}

let start: TimeInterval = 3600*7
let flight = Flight(origin: Airport(city: "Berlin", code: "TXL", time:
    Date(timeIntervalSince1970: start)), destination: Airport(city: "Paris", code: "CDG", time: Date(timeIntervalSince1970: start + 2*3600)), name: "AF123", terminal: "1", gate: "14", boarding: Date(timeIntervalSince1970: start - 1800))

let formatter: DateFormatter = {
    let f = DateFormatter()
    f.dateStyle = .none
    f.timeStyle = .short
    return f
}()

extension Flight {
    var metaData: [(String, String)] {
        return [("FLIGHT", name), ("TERMINAL", terminal), ("GATE", gate), ("BOARDING", formatter.string(from: boarding))]
    }
}

extension Airport {
    func layout(title: String) -> MYPLayout {
        let t = UILabel(text: title, size: .body, textColor: .white).layout.centered
        let c = UILabel(text: code, size: .largeTitle, textColor: .white).layout.centered
        let l = UILabel(text: formatter.string(from: time), size: .body, textColor: .white).layout.centered
        return [t, c, l].vertical().box()
    }
}

extension Flight {
    var layout: MYPLayout {
        let orig = origin.layout(title: "From")
        let orig2 = origin.layout(title: "From")
        let dest = destination.layout(title: "To")
        let dest2 = destination.layout(title: "To")
        let fightBg = UIView(backgroundColor: .gray, cornerRadius: 10)
        let fightBg2 = UIView(backgroundColor: .gray, cornerRadius: 10)
        let fight = [orig, dest].horizontal(space: .flexible(min: 10)).or([orig.centered, dest.centered].vertical(space: 10)).box(wrapper: fightBg, width: .flexible(min: 0))
        let fight2 = [orig2, dest2].horizontal(space: .flexible(min: 10)).or([orig.centered, dest.centered].vertical(space: 10)).box(wrapper: fightBg2, width: .flexible(min: 0))
        let metaItems = metaData.map {
            [UILabel(text: $0.0, size: .caption1, textColor: .white).layout,
            UILabel(text: $0.1, size: .body, textColor: .white).layout,
             ].vertical(space: 0).box()
        }
        let metaItems2 = metaData.map {
            [UILabel(text: $0.0, size: .caption1, textColor: .white).layout,
             UILabel(text: $0.1, size: .body, textColor: .white).layout,
             ].vertical(space: 0).box()
        }
        let meta = metaItems.horizontal(space: .flexible(min: 20)).or(
            [
                metaItems[0...1].horizontal(space: .flexible(min: 20)),
                metaItems[2...3].horizontal(space: .flexible(min: 20))
                ].vertical(space: 10)
        ).or(metaItems.vertical(space: 10))
        let meta2 = metaItems2.horizontal(space: .flexible(min: 20)).or(
            [
                metaItems[0...1].horizontal(space: .flexible(min: 20)),
                metaItems[2...3].horizontal(space: .flexible(min: 20))
                ].vertical(space: 10)
            ).or(metaItems.vertical(space: 10))
        let metaLayout = meta.box(wrapper: UIView(backgroundColor: .red, cornerRadius: 10), width: .flexible(min: 0))
        let metaLayout2 = meta2.box(wrapper: UIView(backgroundColor: .red, cornerRadius: 10), width: .flexible(min: 0))
        let gView = UIView(backgroundColor: .green, cornerRadius: 10)
        let gView2 = UIView(backgroundColor: .green, cornerRadius: 10)
        let label = UILabel(text: "测试垂直居中", size: .body, textColor: .white)
        label.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 100))
        let label2 = UILabel(text: "测试垂直居中2", size: .largeTitle, textColor: .white)
        label2.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 100))
        let layout3 = [label.layout.top(10).box(), label2.layout].horizontal()
        let centerYLayout = layout3.box(wrapper: gView, width: .flexible(min: 0))
        let centerYLayout2 = layout3.box(wrapper: gView2, width: .flexible(min: 0))
        
        return [fight, metaLayout, centerYLayout, centerYLayout2, metaLayout2, fight2].vertical(space: 20)
    }
}

