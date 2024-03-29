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
  case table = "component_table"
}

struct EditingText: View {
  @Binding var b_activeIdx: Int
  let mLabel: String
  let mIdx: Int
  var mIsUnderline: Bool

  var body: some View {
    Text(mLabel)
      .underline(mIsUnderline)
      .onTapGesture {
        b_activeIdx = mIdx
      }
      .background(EditingBorder(mShow: b_activeIdx == mIdx))
  }
}

// 選取到的元件框框
struct EditingBorder: View {
  let mShow: Bool
  var body: some View {
    RoundedRectangle(cornerRadius: 3)
      .stroke(lineWidth: 2)
      .foregroundColor(mShow ? Color.red : Color.clear)
  }
}

// 直線的元件 預設長度100 寬度 2
struct PathView: View {
  @Binding var b_activeIdx: Int
  let mIdx: Int
  let mPathFrame: CGSize
  let mStartPoint: CGPoint
  let mEndPoint: CGPoint
  let mIsDash: Bool
  let mDashLength: CGFloat
  let mLineWidth: CGFloat

  var body: some View {
    Path { path in
      path.move(to: mStartPoint)
      path.addLine(to: mEndPoint)
    }
    .stroke(Color.black, style: StrokeStyle(lineWidth: mLineWidth, dash: mIsDash ? [mDashLength, mDashLength] : [mDashLength, 0]))
    .frame(width: mPathFrame.width, height: mPathFrame.height)
    .onTapGesture {
      b_activeIdx = mIdx
    }
    .background(
      EditingBorder(mShow: b_activeIdx == mIdx)
    )
  }
}

// 長方形
struct RectangleView: View {
  @Binding var b_activeIdx: Int
  let mIdx: Int
  let mLineWidth: CGFloat
  let mIsDash: Bool
  let mDashLength: CGFloat
  let mRectFrame: CGSize

  var body: some View {
    Rectangle()
      .inset(by: 1)
      .stroke(Color.black, style: StrokeStyle(lineWidth: mLineWidth, dash: mIsDash ? [mDashLength, mDashLength] : [mDashLength, 0]))
      .frame(width: mRectFrame.width, height: mRectFrame.height)
      .onTapGesture {
        b_activeIdx = mIdx
      }
      .background(
        EditingBorder(mShow: b_activeIdx == mIdx)
      )
  }
}

// 圓角長方形
struct RoundedRectangleView: View {
  @Binding var b_activeIdx: Int
  let mIdx: Int
  let mLineWidth: CGFloat
  let mIsDash: Bool
  let mDashLength: CGFloat
  let mRectFrame: CGSize
  let mRectCorner: CGFloat

  var body: some View {
    RoundedRectangle(cornerRadius: mRectCorner)
      .inset(by: 1)
      .stroke(Color.black, style: StrokeStyle(lineWidth: mLineWidth, dash: mIsDash ? [mDashLength, mDashLength] : [mDashLength, 0]))
      .frame(width: mRectFrame.width, height: mRectFrame.height)
      .onTapGesture {
        b_activeIdx = mIdx
      }
      .background(
        EditingBorder(mShow: b_activeIdx == mIdx)
      )
  }
}

// 圓形
struct CircleView: View {
  @Binding var b_activeIdx: Int
  let mIdx: Int
  let mLineWidth: CGFloat
  let mIsDash: Bool
  let mDashLength: CGFloat
  let mCircleFrame: CGSize

  var body: some View {
    Circle()
      .inset(by: 1)
      .stroke(Color.black, style: StrokeStyle(lineWidth: mLineWidth, dash: mIsDash ? [mDashLength, mDashLength] : [mDashLength, 0]))
      .frame(width: mCircleFrame.width, height: mCircleFrame.height)
      .onTapGesture {
        b_activeIdx = mIdx
      }
      .background(
        EditingBorder(mShow: b_activeIdx == mIdx)
      )
  }
}

// 橢圓形
struct OvalView: View {
  @Binding var b_activeIdx: Int
  let mIdx: Int
  let mLineWidth: CGFloat
  let mIsDash: Bool
  let mDashLength: CGFloat
  let mOvalFrame: CGSize

  var body: some View {
    RoundedRectangle(cornerSize: CGSize(width: mOvalFrame.width/2, height: mOvalFrame.height/2))
      .inset(by: 1)
      .stroke(Color.black, style: StrokeStyle(lineWidth: mLineWidth, dash: mIsDash ? [mDashLength, mDashLength] : [mDashLength, 0]))
      .frame(width: mOvalFrame.width, height: mOvalFrame.height)
      .onTapGesture {
        b_activeIdx = mIdx
      }
      .background(
        EditingBorder(mShow: b_activeIdx == mIdx)
      )
  }
}

// 表格
struct TableView: View {
  @Binding var b_activeIdx: Int
  // 在array的第幾個
  @Binding var b_numbersInside: (Int, Int)
  // 彈出視窗編輯表格文字
  @Binding var b_isPopover: Bool
  // 彈出設定的視窗
  @Binding var b_isControlViewShow: Bool
  
  // 序號
  let mIdx: Int
  // 表格內容 [橫列[直列]]
  var mInputArr: [[String]] = [["1", "2"], ["1", "2"]]
  // 線條粗細
  var mLineWidth: CGFloat = 2
  // 表格總大小
  var mFrameWidth: CGFloat = 100
  var mFrameHeight: CGFloat = 100
  // 水平有幾格
  var mHorizontalCount: Int = 2
  // 垂直有幾格
  var mVerticalCount: Int = 2
  // 文字大小
  var mTextSize: CGFloat = 15

  var body: some View {
    VStack {
      // 間隙為負的，要讓邊框重疊
      HStack(spacing: -1*mLineWidth) {
        ForEach(mInputArr.indices, id: \.self) { index in

          VStack(spacing: -1*mLineWidth) {
            ForEach(mInputArr[index].indices, id: \.self) { num in

              Text("\(mInputArr[index][num])")
                .frame(width: mFrameWidth/CGFloat(mHorizontalCount), height: mFrameHeight/CGFloat(mVerticalCount))
                .font(Font.system(size: mTextSize))
                .background(
                  Rectangle()
                    .inset(by: 1)
                    .stroke(Color.black, style: StrokeStyle(lineWidth: mLineWidth))
                )
                .overlay(
                  Color.gray
                    .opacity(0.01)
                  // 點兩下可以更改表格內容
                    .onTapGesture(count: 2, perform: {
                      b_numbersInside = (index, num)
                      b_isPopover = true
                    })
                )
            }
          }
        }
      }
    }
    .onTapGesture {
      b_activeIdx = mIdx
      b_isControlViewShow = true
    }
    .background(
      EditingBorder(mShow: b_activeIdx == mIdx)
    )
  }
}
