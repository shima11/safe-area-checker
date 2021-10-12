//
//  ContentView.swift
//  safe-area-chacker
//
//  Created by Jinsei Shima on 2021/10/12.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    GeometryReader { proxy in
      VStack {
        Spacer()
        VStack(alignment: .leading, spacing: 12) {
          Text(String("\(getSystemInfo())"))
//          Text(String("size: \(proxy.size)"))
//          Text(String("local frame:\(proxy.frame(in: .local))"))
          Text(String("frame:\(proxy.frame(in: .global))"))
          Text(String("screen size:\(UIScreen.main.bounds)"))
          Text(String("safe area insets:\(proxy.safeAreaInsets)"))
          Text(String("status bar height:\(getStatusBarHeight())"))
        }
        .padding(.horizontal, 24)
        Spacer()
      }
      .background(Color.white)
      .background(Color.green.edgesIgnoringSafeArea(.all))
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


func getSystemInfo() -> String {
  [
    UIDevice.current.name,
    UIDevice.current.localizedModel,
    UIDevice.current.systemName,
    UIDevice.current.systemVersion,
  ]
    .compactMap { $0 }
    .joined(separator: ",")
}

func getStatusBarHeight() -> CGFloat{
  if #available(iOS 13.0, *) {
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
  } else {
    return UIApplication.shared.statusBarFrame.height
  }
}
