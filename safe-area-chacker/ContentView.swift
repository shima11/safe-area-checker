//
//  ContentView.swift
//  safe-area-chacker
//
//  Created by Jinsei Shima on 2021/10/12.
//

import SwiftUI

// TODO: Orientation
// TODO: NavigationController
// TODO: TabBarController

struct ContentView: View {
  var body: some View {
    GeometryReader { proxy in
      HStack {
        Spacer()
        VStack {
          Spacer()
          VStack(alignment: .leading, spacing: 12) {
            Text("safe-area-checker").font(.title)
            Text(String("\(getSystemInfo())"))
            //          Text(String("size: \(proxy.size)"))
            //          Text(String("local frame:\(proxy.frame(in: .local))"))
            Text(String("frame:\(proxy.frame(in: .global))"))
            Text(String("screen size:\(UIScreen.main.bounds)"))
            Text(String("status bar height:\(getStatusBarHeight())"))
            Text(String("safe area insets:\(proxy.safeAreaInsets)"))
            Text(String("window safe area:\(getWindowSafeArea())"))
          }
          .padding(.horizontal, 24)
          Spacer()
        }
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
      .extendSafeArea(additionalSafeAreaInsets: .init(top: 0, left: 0, bottom: 100, right: 0))
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

func getStatusBarHeight() -> CGFloat {
  if #available(iOS 13.0, *) {
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
  } else {
    return UIApplication.shared.statusBarFrame.height
  }
}

func getWindowSafeArea() -> UIEdgeInsets? {
  UIApplication.shared.keyWindow?.safeAreaInsets
}

extension View {
  func extendSafeArea(additionalSafeAreaInsets: UIEdgeInsets) -> some View {
    modifier(ExtendedSafeAreaModifier(additionalSafeAreaInsets: additionalSafeAreaInsets))
  }
}

struct ExtendedSafeAreaModifier: ViewModifier {

  let additionalSafeAreaInsets: UIEdgeInsets

  func body(content: Content) -> some View {
    Container(content: content, additionalSafeAreaInsets: additionalSafeAreaInsets)
//      .edgesIgnoringSafeArea(.all)
  }
  private struct Container: UIViewRepresentable {

    typealias UIViewType = UIView

    let content: Content
    let additionalSafeAreaInsets: UIEdgeInsets

    func makeUIView(context: Context) -> UIViewType {
      let hostingController = UIHostingController(rootView: content)
      hostingController.additionalSafeAreaInsets = additionalSafeAreaInsets
      context.coordinator.container = hostingController
      return hostingController.view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
      uiView.setNeedsLayout()
    }
    func makeCoordinator() -> Coordinator {
      .init()
    }
    class Coordinator {
      var container: UIViewController!
    }
  }
}
