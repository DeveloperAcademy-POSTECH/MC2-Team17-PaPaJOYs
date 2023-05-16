//
//  ForJoyWidget.swift
//  ForJoyWidget
//
//  Created by Nayeon Kim on 2023/05/16.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct ForJoyWidgetEntryView : View {
    var entry: Provider.Entry
    private static let deeplinkURL: URL = URL(string: "forjoy://")!

    var body: some View {
        ZStack {
            Color("JoyDarkG")
            VStack {
                Image("WidgetCover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
        }
        .widgetURL(ForJoyWidgetEntryView.deeplinkURL)
    }
}

struct ForJoyWidget: Widget {
    let kind: String = "ForJoyWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ForJoyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("For Joy")
        .description("아이에게 전하고 싶은 이야기")
    }
}

struct ForJoyWidget_Previews: PreviewProvider {
    static var previews: some View {
        ForJoyWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
