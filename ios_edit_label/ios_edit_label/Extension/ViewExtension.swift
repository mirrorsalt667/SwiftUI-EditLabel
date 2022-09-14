//
//  ViewExtension.swift
//  ios_edit_label
//
//  Created by sw_user03 on 2022/9/13.
//

import SwiftUI

extension View {
  func snapshot() -> UIImage {
    let controller = UIHostingController(rootView: edgesIgnoringSafeArea(.all))
    let view = controller.view

    let targetSize = controller.view.intrinsicContentSize
    view?.bounds = CGRect(origin: .zero, size: targetSize)
    view?.backgroundColor = .clear

    let renderer = UIGraphicsImageRenderer(size: targetSize)

    return renderer.image { _ in
      view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    }
  }
}

// MARK: - NavigationBar Height

struct NavBarAccessor: UIViewControllerRepresentable {
  var callback: (UINavigationBar) -> Void
  private let proxyController = ViewController()

  func makeUIViewController(context: UIViewControllerRepresentableContext<NavBarAccessor>) ->
    UIViewController
  {
    proxyController.callback = callback
    return proxyController
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavBarAccessor>) {}

  typealias UIViewControllerType = UIViewController

  private class ViewController: UIViewController {
    var callback: (UINavigationBar) -> Void = { _ in }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      if let navBar = navigationController {
        callback(navBar.navigationBar)
      }
    }
  }
}
