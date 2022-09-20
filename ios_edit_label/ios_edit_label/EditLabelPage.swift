//
//  EditLabelPage.swift
//  ios_edit_label
//
//  Created by sw_user03 on 2022/9/13.
//

// MARK: 編輯標籤頁面

import SwiftUI

struct ComponentsIdxType: Codable {
  // 產生的序號
  let idx: Int
  // 元件種類
  let componentType: String
  // 位置點位
  var point: CGPoint
  // 長寬
  var frameSize: CGSize
  // 角度 上下左右
  var degree: Double
  // 文字內容
  var textContent: String
  // 文字大小
  var textSize: CGFloat
  // 粗體
  var textIsBold: Bool
  // 斜體
  var textIsItalic: Bool
  // 底線
  var textIsUnderline: Bool
  // Rectangle
  var rectLineWidth: CGFloat
  var pathPoint: CGPoint
  // 虛線嗎
  var rectIsDash: Bool
  var rectDashLength: CGFloat
  // 黑色背景
//  var rectIsBlackBackground: Bool
  // 長方形圓角
  var rectCornerRadius: CGFloat
}

// MARK: - main View

struct EditLabelPage: View {
  // 下面文字控制盤的升降
  @State private var mTextControlShow: Bool = false
  // 文字控制盤偏移
  @State private var mTextOffsetY: CGFloat = 0
  // 螢幕長寬比
  @State private var mLabelRatio: CGFloat = 3 / 4
  // 選取中的元件index數字
  @State private var mActiveIdx: Int = -1
  // Text資料陣列
  @State private var mMainComponentsArr = [ComponentsIdxType]()

  // 彈出視窗（文字更改用）
  @State private var mIsTextPopoverShow: Bool = false

  // 時間
  @State private var mReturnTimeStr: String = "1"
  // 製造日期頁面的Bool
  @State private var mIsCreateDatePageShow: Bool = false

  // 新增形狀元件的頁面、位移量
  @State private var mIsNewRectShow: Bool = false
  @State private var mNewRectOffsetY: CGFloat = 0

  // 控制盤的出現與消失
  @State private var mIsControlShow: Bool = false

  // 畫布的寬度 距離兩邊各為9，故減18
  private var mInsideLabelWidth: CGFloat {
    UIScreen.main.bounds.width - 18
  }

  // 下方工具列的圖片名稱
  private let mToolBarImageNameArray: [String] = ["list.bullet.rectangle", "t.square", "clock", "rectangle", "lineweight", "tablecells", "barcode", "qrcode", "photo"]

  // MARK: - BODY

  var body: some View {
    // 取得上、下安全範圍的高度
    let topSafeAreaHeight = getSafeAreaTop()
    let bottomSafeAreaHeight = getSafeAreaBottom()
    let navigationHeght: CGFloat = 50 // 暫定為50
    // 標籤範圍的高度
    let insideHeight = mInsideLabelWidth * mLabelRatio

    // 拖曳、觸控移動
    let drag = DragGesture(minimumDistance: 20).onChanged { value in
      // drag point 觸控的點位是全螢幕的，要另外換算成標籤內部的數值。
      let globalPoint = value.location
      let point = CGPoint(x: value.location.x - 9, y: value.location.y - topSafeAreaHeight - navigationHeght)
      if mActiveIdx >= 0 {
        // 計算在範圍內才能滑動
        let leadingTopPoint = CGPoint(x: 9, y: topSafeAreaHeight + navigationHeght)
        let trailingBottomPoint = CGPoint(x: leadingTopPoint.x + mInsideLabelWidth, y: leadingTopPoint.y + insideHeight)
        if globalPoint.x > leadingTopPoint.x && globalPoint.y > leadingTopPoint.y && globalPoint.x < trailingBottomPoint.x && globalPoint.y < trailingBottomPoint.y {
          mMainComponentsArr[mActiveIdx].point = point
        }
      }
    }
    let tapGesture = TapGesture(count: 1).onEnded { () in
      mActiveIdx = -99
    }

    VStack(spacing: 0) {
      selfRectView()
      Button {
        let uiImage = selfRectView().snapshot()
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
      } label: {
        Text("完成")
          .padding(.top, 10)
          .padding(.bottom, 10)
          .padding(.leading, 20)
          .padding(.trailing, 20)
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .border(Color("TiffanyBlue"))
              .foregroundColor(Color.clear)
          )
      }
      .padding()

      ControlComponentsView(b_isShow: $mIsControlShow, b_componentsArr: $mMainComponentsArr, mActiveIdx: mActiveIdx)
        .opacity(mIsControlShow ? 1 : 0)

      Color.black

      // 功能列( 橫向捲動 )
      ZStack {
        // 8 -> 20.0
        // 7plus -> 20.0
        // 11 -> 48.0
        // 11pro -> 44.0
        // 11pro max -> 44.0
        // 控制盤的上升下降
        if mTextControlShow {
          thisIsAView()
            .onAppear {
              withAnimation(.linear(duration: 0.4)) {
                self.mTextOffsetY = 0
              }
            }
        } else {
          thisIsAView()
            .onAppear {
              withAnimation(.linear(duration: 0.2)) {
                self.mTextOffsetY = 120
              }
            }
        }

        if mIsNewRectShow {
          CreateNewRectView(b_isShowing: $mIsNewRectShow, b_componentsArr: $mMainComponentsArr, mOffsetY: mNewRectOffsetY)
            .onAppear {
              withAnimation(.linear(duration: 0.4)) {
                mNewRectOffsetY = 0
              }
            }
        } else {
          CreateNewRectView(b_isShowing: $mIsNewRectShow, b_componentsArr: $mMainComponentsArr, mOffsetY: mNewRectOffsetY)
            .onAppear {
              withAnimation(.linear(duration: 0.2)) {
                mNewRectOffsetY = 120
              }
            }
        }

        ScrollView(.horizontal) {
          LazyHGrid(rows: [GridItem(.flexible())]) {
            ForEach(mToolBarImageNameArray.indices, id: \.self) { idxNum in
              switch idxNum {
              case 0: // 控制盤上下移
                Button {
                  mTextControlShow.toggle()
                } label: {
                  Image(systemName: mToolBarImageNameArray[idxNum])
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                }
              case 1: // 加一個文字
                Button {
                  mMainComponentsArr.append(ComponentsIdxType(
                    idx: mMainComponentsArr.count,
                    componentType: ComponentTypeEnum.text.rawValue,
                    point: CGPoint(x: mInsideLabelWidth / 2, y: insideHeight / 2),
                    frameSize: CGSize(width: 120, height: 50),
                    degree: 0,
                    textContent: "Test\(mMainComponentsArr.count)",
                    textSize: 15,
                    textIsBold: false,
                    textIsItalic: false,
                    textIsUnderline: false,
                    rectLineWidth: 2,
                    pathPoint: CGPoint(),
                    rectIsDash: false,
                    rectDashLength: 0,
                    rectCornerRadius: 0
                  ))
                } label: {
                  Image(systemName: mToolBarImageNameArray[idxNum])
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                }
              case 2: // 跳到選擇日期時間的頁面
                NavigationLink(isActive: $mIsCreateDatePageShow) {
                  CreateTimeText(finalDate: $mReturnTimeStr)
                } label: {
                  Image(systemName: mToolBarImageNameArray[idxNum])
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                }
                .onAppear {
                  if mReturnTimeStr != "1" {
                    mMainComponentsArr.append(
                      ComponentsIdxType(idx: mMainComponentsArr.count,
                                        componentType: ComponentTypeEnum.text.rawValue,
                                        point: CGPoint(x: mInsideLabelWidth / 2, y: insideHeight / 2),
                                        frameSize: CGSize(width: 120, height: 50),
                                        degree: 0,
                                        textContent: mReturnTimeStr.description,
                                        textSize: 15,
                                        textIsBold: false,
                                        textIsItalic: false,
                                        textIsUnderline: false,
                                        rectLineWidth: 2,
                                        pathPoint: CGPoint(),
                                        rectIsDash: false,
                                        rectDashLength: 0,
                                        rectCornerRadius: 0)
                    )
                    mReturnTimeStr = "1"
                  }
                }
              case 3:
                Button {
                  mIsNewRectShow.toggle()
                } label: {
                  Image(systemName: mToolBarImageNameArray[idxNum])
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                }
              case 4:
                Button {
                  mIsControlShow.toggle()
                } label: {
                  Image(systemName: mToolBarImageNameArray[idxNum])
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                }
              default:
                Image(systemName: mToolBarImageNameArray[idxNum])
                  .font(.system(size: 40, weight: .medium, design: .rounded))
                  .foregroundColor(.white)
              }
            }
          }
        }
        .background(Color("DeepLogoGreen"))
      }
      .frame(height: 80)
    }
    .padding(.bottom, bottomSafeAreaHeight)
    .padding(.top, topSafeAreaHeight + navigationHeght)
    // 點擊回傳點擊位置，回傳的是最外層的數值，要經過處理才是框框裡的數值
    .gesture(drag)
    .gesture(tapGesture)
    .background(Color.black)
    .edgesIgnoringSafeArea(.all)
  }

  // MARK: - Function

  private func getSafeAreaTop() -> CGFloat {
    let windows = UIApplication.shared.windows.first
    let topPadding = windows?.safeAreaInsets.top
    if let padding = topPadding {
      if padding > 0 {
        return padding
      }
    }
    return 0
  }

  private func getSafeAreaBottom() -> CGFloat {
    let windows = UIApplication.shared.windows.first
    let bottomPadding = windows?.safeAreaInsets.bottom
    if let padding = bottomPadding {
      if padding > 0 {
        return padding
      }
    }
    return 0
  }

  // MARK: - ViewBuilder

  @ViewBuilder
  private func selfRectView() -> some View {
    let insideHeight = mInsideLabelWidth * mLabelRatio
    RoundedRectangle(cornerRadius: 0, style: .continuous)
      .frame(width: mInsideLabelWidth, height: insideHeight, alignment: .top)
      .foregroundColor(Color.white)
      .overlay(
        ZStack {
          ForEach(mMainComponentsArr.indices, id: \.self) { index in

            let idx = mMainComponentsArr[index].idx
            let centerPoint = mMainComponentsArr[index].point
            let width = mMainComponentsArr[index].frameSize.width
            let height = mMainComponentsArr[index].frameSize.height
            let isDash = mMainComponentsArr[index].rectIsDash
            let dashLength = mMainComponentsArr[index].rectDashLength
            let lineWidth = mMainComponentsArr[index].rectLineWidth
            let pathPoint = mMainComponentsArr[index].pathPoint

            switch mMainComponentsArr[index].componentType {
            case ComponentTypeEnum.text.rawValue:
              // $activeIdx 代表 activeIdx 會隨 editingText變動。
              EditingText(activeText: $mActiveIdx,
                          label: mMainComponentsArr[index].textContent,
                          idx: idx,
                          underlineBool: mMainComponentsArr[index].textIsUnderline)
                .background(
                  GeometryReader(content: { geometry in
                    Color.clear.onAppear {
                      mMainComponentsArr[index].frameSize = geometry.frame(in: .global).size
                    }
                  })
                )
                .position(centerPoint) // 這是在標籤範圍裡面的點位 text的center
                .font(mMainComponentsArr[index].textIsBold ? mMainComponentsArr[index].textIsItalic ? .system(size: mMainComponentsArr[index].textSize).bold().italic() : .system(size: mMainComponentsArr[index].textSize).bold() : mMainComponentsArr[index].textIsItalic ? .system(size: mMainComponentsArr[index].textSize).italic() : .system(size: mMainComponentsArr[index].textSize))

            // 旋轉後移動會跟著旋轉，暫無法使用
//              .rotationEffect(.degrees(textPositions[index].degree))
            case ComponentTypeEnum.line.rawValue:
              PathView(activeIdx: $mActiveIdx, idx: idx, pathFrame: CGSize(width: width, height: height), startPoint: pathPoint, endPoint: CGPoint(x: pathPoint.x + width, y: pathPoint.y), isDash: isDash, dashLength: 5, lineWidth: lineWidth)
                .position(centerPoint)
            case ComponentTypeEnum.rectangle.rawValue:
              RectangleView(activeIdx: $mActiveIdx, idx: idx, lineWidth: lineWidth, isDash: isDash, dashLength: dashLength, rectFrame: CGSize(width: width, height: height))
                .position(centerPoint)
            case ComponentTypeEnum.roundedRectangle.rawValue:
              RoundedRectangleView(activeIdx: $mActiveIdx, idx: idx, lineWidth: lineWidth, isDash: isDash, dashLength: dashLength, rectFrame: CGSize(width: width, height: height), rectCorner: mMainComponentsArr[index].rectCornerRadius)
                .position(centerPoint)
            case ComponentTypeEnum.circle.rawValue:
              CircleView(activeIdx: $mActiveIdx, idx: idx, lineWidth: lineWidth, isDash: isDash, dashLength: dashLength, circleFrame: CGSize(width: width, height: height))
                .position(centerPoint)
            case ComponentTypeEnum.oval.rawValue:
              OvalView(activeIdx: $mActiveIdx, idx: idx, lineWidth: lineWidth, isDash: isDash, dashLength: dashLength, ovalFrame: CGSize(width: width, height: height))
                .position(centerPoint)
            default: EmptyView()
            }
          }
        }
      )
  }

  private func thisIsAView() -> some View {
    VStack(spacing: 10) {
      Rectangle()
        .frame(width: 60, height: 6)
        .cornerRadius(3.0)
        .opacity(0.1)
        .gesture(DragGesture(minimumDistance: 5, coordinateSpace: .global)
          .onEnded { value in
            let horizontalAmount = value.translation.width
            let verticalAmount = value.translation.height

            let points = value.location
            print(points)
            if abs(horizontalAmount) > abs(verticalAmount) {
              print(horizontalAmount < 0 ? "left swipe" : "right swipe")
            } else {
              print(verticalAmount < 0 ? "up swipe" : "down swipe")
              mTextControlShow = verticalAmount < 0
            }
          })
      Text("Setting")
        .lineLimit(1)
        .foregroundColor(.black)
        .frame(height: 40)
      HStack(spacing: 10) {
        Button {
          if mActiveIdx >= 0 {
            let sizeNum = mMainComponentsArr[mActiveIdx].textSize
            mMainComponentsArr[mActiveIdx].textSize = sizeNum + 1
          }
        } label: {
          Image(systemName: "plus.magnifyingglass")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        Button {
          if mActiveIdx >= 0 {
            let sizeNum = mMainComponentsArr[mActiveIdx].textSize
            if sizeNum > 0 {
              mMainComponentsArr[mActiveIdx].textSize = sizeNum - 1
            }
          }
        } label: {
          Image(systemName: "minus.magnifyingglass")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        Button {
          let bool = mMainComponentsArr[mActiveIdx].textIsBold
          mMainComponentsArr[mActiveIdx].textIsBold = !bool
        } label: {
          Image(systemName: "bold")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        Button {
          let bool = mMainComponentsArr[mActiveIdx].textIsItalic
          mMainComponentsArr[mActiveIdx].textIsItalic = !bool
        } label: {
          Image(systemName: "italic")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        Button {
          let bool = mMainComponentsArr[mActiveIdx].textIsUnderline
          mMainComponentsArr[mActiveIdx].textIsUnderline = !bool
        } label: {
          Image(systemName: "underline")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        Button {
          mIsTextPopoverShow = true
        } label: {
          Image(systemName: "pencil.circle")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        .popover(isPresented: $mIsTextPopoverShow) {
          VStack(spacing: 30) {
            HStack {
              TextField("EditTextField", text: $mMainComponentsArr[mActiveIdx].textContent)
                .font(.system(size: 18))
                .foregroundColor(.black)
                .frame(width: 300)
                .textFieldStyle(.roundedBorder)
            }
            Button {
              mIsTextPopoverShow = false
            } label: {
              Text("確認")
            }
          }
        }
//        Button {
//          switch textPositions[activeIdx].degree {
//          case 0, 90, 180: textPositions[activeIdx].degree += 90
//          case 270: textPositions[activeIdx].degree = 0
//          default: break
//          }
//        } label: {
//          Image(systemName: "arrow.clockwise.circle")
//            .font(.system(size: 30))
//            .frame(width: 35, height: 35)
//        }.hidden()
//        Button {
//          switch textPositions[activeIdx].degree {
//          case 90, 180, 270: textPositions[activeIdx].degree -= 90
//          case 0: textPositions[activeIdx].degree = 270
//          default: break
//          }
//        } label: {
//          Image(systemName: "arrow.counterclockwise.circle")
//            .font(.system(size: 30))
//            .frame(width: 35, height: 35)
//        }.hidden()
//        Color("LogoGreen")
      }
      Color("LogoGreen")
        .frame(height: 120)
    }
    .frame(minWidth: 0, maxWidth: .infinity)
    .background(Color("LogoGreen"))
    .cornerRadius(30)
    .shadow(radius: 20)
    // 上下移動的變量
    .position(x: UIScreen.main.bounds.width / 2, y: mTextOffsetY)
  }
}

// MARK: Previews

struct EditLabelPage_Previews: PreviewProvider {
  static var previews: some View {
    EditLabelPage()
      .previewDevice(PreviewDevice(rawValue: "iPhone 12 pro"))
      .previewDisplayName("Edit Page")
  }
}
