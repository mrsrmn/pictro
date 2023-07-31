//
//  Scribble.swift
//  Scribble
//
//  Created by Emir Sürmen on 31.07.2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct ScribbleEntryView : View {
    var entry: Provider.Entry
    
    var bundle: URL {
       let bundle = Bundle.main
       if bundle.bundleURL.pathExtension == "appex" {
           var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
           url.append(component: "Frameworks/App.framework/flutter_assets")
           return url
       }
       return bundle.bundleURL
    }
    
    init(entry: Provider.Entry){
        self.entry = entry
        CTFontManagerRegisterFontsForURL(bundle.appending(path: "/assets/fonts/Geologica/static/Geologica-Medium.ttf") as CFURL, CTFontManagerScope.process, nil)
    }

    var body: some View {
        ZStack {
          Color(hex: 0xff9F27A5)
          
          ContainerRelativeShape()
            .inset(by: 7)
            .fill(Color(hex: 0xDD000000))
          
          LinearGradient(
            colors: [
                Color(hex: 0xFFAB47BC),
                Color(hex: 0xFF7B1FA2)
            ],
            startPoint: .leading,
            endPoint: .trailing
          ).mask {
              Text("Scribble")
                    .font(Font.custom("Geologica Roman", size: 20).weight(.medium))
                .padding()
          }
        }
    }
}

struct Scribble: Widget {
    let kind: String = "Scribble"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ScribbleEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("See Scribbs")
        .description("Use this widget to see Scribb's your friends sent you!")
    }
}

struct Scribble_Previews: PreviewProvider {
    static var previews: some View {
        ScribbleEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
