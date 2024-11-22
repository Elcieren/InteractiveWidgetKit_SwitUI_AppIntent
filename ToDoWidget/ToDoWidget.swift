//
//  ToDoWidget.swift
//  ToDoWidget
//
//  Created by Eren Elçi on 22.11.2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ToDoEntry {
        ToDoEntry(toDoToDisplay: Array(SharedDatas.shared.toDos.prefix(3)))
    }

    func getSnapshot(in context: Context, completion: @escaping (ToDoEntry) -> ()) {
        let entry = ToDoEntry(toDoToDisplay: Array(SharedDatas.shared.toDos.prefix(3)))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let toDisplay =  Array(SharedDatas.shared.toDos.prefix(3))
        let timeline = Timeline(entries: [ToDoEntry(toDoToDisplay: toDisplay)], policy: .atEnd)
        completion(timeline)
    }


}



struct ToDoEntry: TimelineEntry {
    let date: Date = .now
    var toDoToDisplay : [ToDo]
}




struct ToDoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("ToDo Items")
                .fontWeight(.bold)
                .padding(.bottom, 5)
            VStack {
                if entry.toDoToDisplay.isEmpty {
                    Text("ToDos Completed")
                } else {
                    ForEach(entry.toDoToDisplay) { toDo in
                        HStack {
                            Button(intent: ComplateToDoIntent(id: toDo.id)) {
                                Image(systemName: toDo.isDone ? "checkmark.circle.fill" : "circle").foregroundStyle(.blue)
                            }.buttonStyle(.plain)
                            
                            VStack(alignment: .leading) {
                                Text(toDo.name).lineLimit(1).textScale(.secondary).strikethrough(toDo.isDone)
                                Divider()
                            }
                        }
                    }
                }
                    
            }
        }
    }
}






struct ToDoWidget: Widget {
    let kind: String = "ToDoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ToDoWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ToDoWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("ToDo Widget")
        .description("ToDo Widget with Interactions")
    }
}





#Preview(as: .systemSmall) {
    ToDoWidget()
} timeline: {
    ToDoEntry(toDoToDisplay: Array(SharedDatas.shared.toDos.prefix(3)))
    ToDoEntry(toDoToDisplay: Array(SharedDatas.shared.toDos.reversed().prefix(3)))

}
