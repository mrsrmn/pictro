//
//  Pictro.swift
//  pictro
//
//  Created by Emir Sürmen on 31.07.2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PictroEntry {
        PictroEntry(date: Date(), pictrImage: nil, sentBy: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (PictroEntry) -> ()) {
        let entry: PictroEntry
        
        if (context.isPreview) {
            entry = placeholder(in: context)
        } else {
            let userDefaults = UserDefaults(suiteName: "group.pictrowidget")
            let pictrUrl = userDefaults?.string(forKey: "pictr_url")
            let sentBy = userDefaults?.string(forKey: "sent_by")

            entry = PictroEntry(date: Date(), pictrImage: pictrUrl, sentBy: sentBy)
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

struct PictroEntry: TimelineEntry {
    var date: Date
    var pictrImage: String?
    var sentBy: String?
}

struct PictroEntryView : View {
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
            .fill(Color(hex: 0xff222122))
          
            if (entry.pictrImage == nil) {
                Text("Nothing yet!")
                  .font(Font.custom("Geologica Roman", size: 18).weight(.medium))
            } else {
                NetworkImage(url: URL(string: entry.pictrImage!))
                    .padding(7)
            }
        }
    }
}

struct Pictro: Widget {
    let kind: String = "Pictro"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PictroEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("See Pictr's")
        .description("Use this widget to see Pictr's your friends sent you!")
    }
}

struct Pictro_Previews: PreviewProvider {
    static var previews: some View {
        PictroEntryView(entry: PictroEntry(date: Date()))
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
              Text("Pictro")
                .font(Font.custom("Geologica Roman", size: 20).weight(.medium))
                .padding()
          }
      }
    }
  }

}
