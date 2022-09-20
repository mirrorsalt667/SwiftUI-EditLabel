//
//  ComponentsEnumAndViews.swift
//  ios_edit_label
//
//  Created by sw_user03 on 2022/9/20.
//

// MARK: 文字、方形等元件頁面

import SwiftUI

enum ComponentTypeEnum: String {
  case text = "component_text"
  case line = "component_line"
  case rectangle = "component_rectangle"
  case roundedRectangle = "component_roundedRectangle"
  case circle = "component_circle"
  case oval = "component_oval"
}

struct EditingText: View {
  @Binding var activeText: Int
  let label: String
  let idx: Int
  var underlineBool: Bool

  var body: some View {
    Text(label)
      .underline(underlineBool)
      .onTapGesture {
        self.activeText = self.idx
      }
      .background(EditingBorder(show: activeText == idx))
  }
}

// 選取到的元件框框
struct EditingBorder: View {
  let show: Bool
  var body: some View {
    RoundedRectangle(cornerRadius: 3)
      .stroke(lineWidth: 2)
      .foregroundColor(show ? Color.red : Color.clear)
  }
}

// 直線的元件 預設長度100 寬度 2
struct PathView: View {
  @Binding var activeIdx: Int
  let idx: Int
  let pathFrame: CGSize
  let startPoint: CGPoint
  let endPoint: CGPoint
  let isDash: Bool
  let dashLength: CGFloat
  let lineWidth: CGFloat

  var body: some View {
    Path { path in
      path.move(to: startPoint)
      path.addLine(to: endPoint)
    }
    .stroke(Color.black, style: StrokeStyle(lineWidth: lineWidth, dash: isDash ? [dashLength, dashLength] : [dashLength, 0]))
    .frame(width: pathFrame.width, height: pathFrame.height)
    .onTapGesture {
      activeIdx = idx
    }
    .background(
      EditingBorder(show: activeIdx == idx)
    )
  }
}

// 長方形
struct RectangleView: View {
  @Binding var activeIdx: Int
  let idx: Int
  let lineWidth: CGFloat
  let isDash: Bool
  let dashLength: CGFloat
  let rectFrame: CGSize

  var body: some View {
    Rectangle()
      .inset(by: 1)
      .stroke(Color.black, style: StrokeStyle(lineWidth: lineWidth, dash: isDash ? [dashLength, dashLength] : [dashLength, 0]))
      .frame(width: rectFrame.width, height: rectFrame.height)
      .onTapGesture {
        self.activeIdx = self.idx
      }
      .background(
        EditingBorder(show: activeIdx == idx)
      )
  }
}

// 圓角長方形
struct RoundedRectangleView: View {
  @Binding var activeIdx: Int
  let idx: Int
  let lineWidth: CGFloat
  let isDash: Bool
  let dashLength: CGFloat
  let rectFrame: CGSize
  let rectCorner: CGFloat

  var body: some View {
    RoundedRectangle(cornerRadius: rectCorner)
      .inset(by: 1)
      .stroke(Color.black, style: StrokeStyle(lineWidth: lineWidth, dash: isDash ? [dashLength, dashLength] : [dashLength, 0]))
      .frame(width: rectFrame.width, height: rectFrame.height)
      .onTapGesture {
        self.activeIdx = self.idx
      }
      .background(
        EditingBorder(show: activeIdx == idx)
      )
  }
}

// 圓形
struct CircleView: View {
  @Binding var activeIdx: Int
  let idx: Int
  let lineWidth: CGFloat
  let isDash: Bool
  let dashLength: CGFloat
  let circleFrame: CGSize

  var body: some View {
    Circle()
      .inset(by: 1)
      .stroke(Color.black, style: StrokeStyle(lineWidth: lineWidth, dash: isDash ? [dashLength, dashLength] : [dashLength, 0]))
      .frame(width: circleFrame.width, height: circleFrame.height)
      .onTapGesture {
        self.activeIdx = self.idx
      }
      .background(
        EditingBorder(show: activeIdx == idx)
      )
  }
}

// 橢圓形
struct OvalView: View {
  @Binding var activeIdx: Int
  let idx: Int
  let lineWidth: CGFloat
  let isDash: Bool
  let dashLength: CGFloat
  let ovalFrame: CGSize

  var body: some View {
    RoundedRectangle(cornerSize: CGSize(width: ovalFrame.width/2, height: ovalFrame.height/2))
      .inset(by: 1)
      .stroke(Color.black, style: StrokeStyle(lineWidth: lineWidth, dash: isDash ? [dashLength, dashLength] : [dashLength, 0]))
      .frame(width: ovalFrame.width, height: ovalFrame.height)
      .onTapGesture {
        self.activeIdx = self.idx
      }
      .background(
        EditingBorder(show: activeIdx == idx)
      )
  }
}
