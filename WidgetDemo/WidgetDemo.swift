//
//  WidgetDemo.swift
//  WidgetDemo
//
//  Created by SUNG HAO LIN on 2020/9/7.
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

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
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

struct ICSmallWidgetView: View {
  var body: some View {
    ZStack {
      Image("backgroundImage")
        .resizable()
        .background(Color.white)
      LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]),
                     startPoint: .top,
                     endPoint: .bottom).opacity(0.5)
      VStack {
        HStack(alignment: .center, spacing: 0, content: {
          Spacer()
          Image("ios-frontpage-vip-logo")
        }).padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 16))
        VStack(alignment: .leading, spacing: 2, content: {
          Spacer()
          Text("爸爸煮什麼")
            .font(.system(size: 10, weight: .bold, design: .default))
            .foregroundColor(Color.white)
            .lineLimit(1)
          Text("茶碗蒸，像餐廳一樣Q嫩嫩得茶碗蒸")
            .font(.system(size: 12, weight: .bold, design: .default))
            .foregroundColor(Color.white)
            .lineLimit(2)
        }).padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
      }
    }
  }
}

struct ICWidgetCell: View {
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 0, content: {
        Text("茶碗蒸，像餐廳一樣 Q 嫩嫩的茶碗蒸")
          .font(.system(size: 12, weight: .light, design: .default))
          .frame(width: .infinity, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          .foregroundColor(Color.black)
          .lineLimit(1)
        Spacer()
        Text("By 爸爸煮什麼")
          .font(.system(size: 12, weight: .light, design: .default))
          .frame(width: .infinity, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          .foregroundColor(.secondary)
          .lineLimit(1)
      })
      Spacer()
      Image("backgroundImage")
        .resizable().frame(width: 48, height: 48)
        .background(Color.white).cornerRadius(10)
    }.frame(width: .infinity, height: 48, alignment: .center)
    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
  }
}

struct ICMediumWidgetView: View {
  @State var isNeedLogo = true

  var body: some View {
    VStack {
      HStack {
        Text("新廚上菜")
          .font(.system(size: 17, weight: .light, design: .default))
          .foregroundColor(Color.red)
          .lineLimit(1)
        Spacer()
        if isNeedLogo {
          Image("ios-frontpage-vip-logo")
        }
      }.padding(EdgeInsets(top: 0, leading: 16, bottom: -3, trailing: 16))
      ICWidgetCell()
      ICWidgetCell()
    }
  }
}

struct ICLargeWidgetView: View {
  var body: some View {
    VStack {
      ICMediumWidgetView()
      Spacer()
      ICMediumWidgetView(isNeedLogo: false)
    }.padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
  }
}

struct WidgetDemoEntryView : View {
  @Environment(\.widgetFamily) private var widgetFamily
  //  var entry: Provider.Entry

  var body: some View {
    switch widgetFamily {
    case .systemSmall:
      ICSmallWidgetView()
    case .systemMedium:
      ICMediumWidgetView()
    case .systemLarge:
      ICLargeWidgetView()
    default:
      Text("iCook's Widget default")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
  }
}

@main
struct WidgetDemo: Widget {
  let kind: String = "WidgetDemo"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      WidgetDemoEntryView()
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct WidgetDemo_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      WidgetDemoEntryView()
        .previewContext(WidgetPreviewContext(family: .systemSmall))
      WidgetDemoEntryView()
        .previewContext(WidgetPreviewContext(family: .systemMedium))
      WidgetDemoEntryView()
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
  }
}
