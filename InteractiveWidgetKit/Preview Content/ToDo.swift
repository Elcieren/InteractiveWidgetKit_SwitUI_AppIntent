//
//  ToDo.swift
//  InteractiveWidgetKit
//
//  Created by Eren Elçi on 22.11.2024.
//

import Foundation


struct ToDo : Identifiable {
    let id: String = UUID().uuidString
    var name: String
    var isDone : Bool = false
}

class SharedDatas {
    
    static let shared = SharedDatas()
    
    var toDos : [ToDo] = [
        .init(name: "Spor Gidiceksin"),
        .init(name: "Toplantiya Katil"),
        .init(name: "Kopegi Yuruyuse Cikar")
    ]
    
}
