//
//  Scribble.swift
//  Scribble
//
//  Created by Emir Sürmen on 31.07.2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ScribbleEntry {
        ScribbleEntry(date: Date(), scribbImage: nil, sentBy: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (ScribbleEntry) -> ()) {
        let entry: ScribbleEntry
        
        if (context.isPreview) {
            entry = placeholder(in: context)
        } else {
            let userDefaults = UserDefaults(suiteName: "group.scribblewidget")
            let scribbUrl = userDefaults?.string(forKey: "scribb_url")!
            let sentBy = userDefaults?.string(forKey: "sent_by")!

            entry = ScribbleEntry(date: Date(), scribbImage: scribbUrl!, sentBy: sentBy)
        }
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
        let timeline = Timeline(entries: [entry], policy: .atEnd)
              completion(timeline)
          }
    }
}

struct ScribbleEntry: TimelineEntry {
    var date: Date
    var scribbImage: String?
    var sentBy: String?
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
    
    init(entry: Provider.Entry) {
        self.entry = entry
        CTFontManagerRegisterFontsForURL(bundle.appending(path: "/assets/fonts/Geologica/static/Geologica-Medium.ttf") as CFURL, CTFontManagerScope.process, nil)
    }

    var body: some View {
        ZStack {
          Color(hex: 0xff9F27A5)
          
          ContainerRelativeShape()
            .inset(by: 7)
            .fill(Color(hex: 0xDD000000))
          
            if (entry.scribbImage == nil) {
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
            } else {
                NetworkImage(url: URL(string: entry.scribbImage!))
                    .padding(7)
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
        ScribbleEntryView(entry: ScribbleEntry(date: Date()))
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

struct NetworkImage: View {
  let url: URL?

  var body: some View {

    Group {
     if let url = url, let imageData = try? Data(contentsOf: url),
       let uiImage = UIImage(data: imageData) {

       Image(uiImage: uiImage)
         .resizable()
         .aspectRatio(contentMode: .fit)
         .clipShape(ContainerRelativeShape())
      }
      else {
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

}
