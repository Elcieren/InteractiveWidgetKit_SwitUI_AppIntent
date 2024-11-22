//
//  ComplateToDoIntent.swift
//  InteractiveWidgetKit
//
//  Created by Eren Elçi on 22.11.2024.
//

import Foundation
import SwiftUI
import AppIntents

struct ComplateToDoIntent : AppIntent {
    
    static var title: LocalizedStringResource = "Complete To Do"
    
    @Parameter(title:"ToDo ID")
    var id: String
    
    init() {
        //bos bir initalion yapmak zorundayiz
    }
    
    init(id: String) {
        self.id = id
    }
    
    
    //Yapilan islem sonucunda ne olucak ne dondurecegiz
    func perform() async throws -> some IntentResult {
        
        if let index = SharedDatas.shared.toDos.firstIndex(where: {
            $0.id == id
        }) {
            SharedDatas.shared.toDos[index].isDone.toggle()
            print("Database update")
        }
        return .result()
    }
    
    
    
}
