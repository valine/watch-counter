//
//  Widget_Extension.swift
//  Widget Extension
//
//  Created by Valine, Lukas on 11/17/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate)
    
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
        
        print("refreshing")
    }

    func recommendations() -> [IntentRecommendation<ConfigurationIntent>] {
        return [
            IntentRecommendation(intent: ConfigurationIntent(), description: "Counter")
        ]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct Widget_ExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Image(systemName: "flame.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .padding(12)
    }
}

@main
struct Widget_Extension: Widget {
    let kind: String = "Widget_Extension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Widget_ExtensionEntryView(entry: entry)
        }
    }
}
