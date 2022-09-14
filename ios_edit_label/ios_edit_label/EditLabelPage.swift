//
//  EditLabelPage.swift
//  ios_edit_label
//
//  Created by sw_user03 on 2022/9/13.
//

import SwiftUI

struct TextIdxType {
  // 產生的序號
  let idx: Int
  // 文字內容
  var textContent: String
  // 位置點位
  var point: CGPoint
  // 位移量
//  var position: CGSize
  // 長寬
  var frameSize: CGSize
  // 文字大小
  var textSize: CGFloat
  // 粗體
  var boldCharacterBool: Bool
  // 斜體
  var italicBool: Bool
  // 底線
  var underlineBool: Bool
  // 角度 上下左右
  var degree: Double
}

struct EditLabelPage: View {
  // 下面控制盤的升降
  @State private var showView: Bool = false
  // 控制盤偏移
  @State private var offsetY: CGFloat = 0
  // 螢幕長寬比
  @State private var ratio: CGFloat = 3 / 4
  // 選取中text的index數字
  @State private var activeIdx: Int = -1
  // Text資料陣列
  @State private var textPositions = [TextIdxType]()

  // 彈出視窗（文字更改用）
  @State private var popoverBool: Bool = false

  // 時間
  @State private var returnTimeStr: String = "1"
  // 製造日期頁面的Bool
  @State private var createDatePageBool: Bool = false

  // 畫布的寬度 距離兩邊各為9，故減18
  private var insideRectWidth: CGFloat {
    UIScreen.main.bounds.width - 18
  }

  // 下方工具列的圖片名稱
  private let imageNameArray: [String] = ["list.bullet.rectangle", "123.rectangle", "clock", "rectangle", "tablecells", "barcode", "qrcode", "photo"]

  // MARK: - BODY

  var body: some View {
    // 取得上、下安全範圍的高度
    let topSafeAreaHeight = getSafeAreaTop()
    let bottomSafeAreaHeight = getSafeAreaBottom()
    let navigationHeght: CGFloat = 50 // 暫定為50
    // 拖曳、觸控移動
    let drag = DragGesture(minimumDistance: 0).onChanged { value in
      // drag point
      let point = CGPoint(x: value.location.x - 9, y: value.location.y)
      if activeIdx >= 0 {
        // Text 的範圍
        let textFrame = CGRect(x: point.x, y: point.y, width: textPositions[activeIdx].frameSize.width, height: textPositions[activeIdx].frameSize.height)
        // Text 的中心
        let textCenter = textPositions[activeIdx].point

        // TODO: 避免觸控失誤，應該把範圍稍微拉大
        if point.x > textCenter.x - (textFrame.width / 2) && point.x < textCenter.x + (textFrame.width / 2) && point.y > textCenter.y - (textFrame.height / 2) && point.y < textCenter.y + (textFrame.height / 2) {
          // 改變Text的位置
          textPositions[activeIdx].point = point
        } else {
          // 不在範圍內的話就設為-99
          activeIdx = -99
        }
      }
    }
    VStack(spacing: 0) {
      let insideHeight = insideRectWidth * ratio
      // safe area 填入黑色
      Color.black
        .frame(height: topSafeAreaHeight + navigationHeght)
//        .onAppear {
//          print(topSafeAreaHeight + navigationHeght)
//        }
      selfRectView()
      Button {
        let uiImage = selfRectView().snapshot()
//        print(insideHeight, insideRectWidth)
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
//            .cornerRadius(20)
          )
      }
      .padding()

      Color.black

      // 功能列( 橫向捲動 )
      ZStack {
        // 8 -> 20.0
        // 7plus -> 20.0
        // 11 -> 48.0
        // 11pro -> 44.0
        // 11pro max -> 44.0
        // 控制盤的上升下降
        if showView {
          thisIsAView()
            .onAppear {
              withAnimation(.linear(duration: 0.4)) {
                self.offsetY = 0
              }
            }
        } else {
          thisIsAView()
            .onAppear {
              withAnimation(.linear(duration: 0.2)) {
                self.offsetY = 120
              }
            }
        }
        ScrollView(.horizontal) {
          LazyHGrid(rows: [GridItem(.flexible())]) {
            ForEach(imageNameArray.indices, id: \.self) { idxNum in
              switch idxNum {
              case 0: // 控制盤上下移
                Button {
                  showView.toggle()
                } label: {
                  Image(systemName: imageNameArray[idxNum])
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                }
              case 1: // 加一個文字
                Button {
                  textPositions.append(TextIdxType(idx: textPositions.count, textContent: "Test\(textPositions.count)", point: CGPoint(x: insideRectWidth / 2, y: insideHeight / 2), frameSize: CGSize(width: 120, height: 50), textSize: 15, boldCharacterBool: false, italicBool: false, underlineBool: false, degree: 0))
                } label: {
                  Image(systemName: imageNameArray[idxNum])
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                }
              case 2: // 跳到選擇日期時間的頁面
                Button {
                  createDatePageBool = true
                } label: {
                  Image(systemName: imageNameArray[idxNum])
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                }
                .sheet(isPresented: $createDatePageBool, content: {
                  CreateTimeText(finalDate: $returnTimeStr, popBool: $createDatePageBool)
                })

//                NavigationLink {
//                  CreateTimeText(finalDate: $returnTimeStr)
//                } label: {
//                  Image(systemName: imageNameArray[idxNum])
//                    .font(.system(size: 40, weight: .medium, design: .rounded))
//                    .foregroundColor(.white)
//                }
                .onAppear {
                  // TODO: 製造一個Text 是日期
                  print("日期製造器")
                  if returnTimeStr != "1" {
                    #warning("textContent 會變動嗎？")
                    textPositions.append(TextIdxType(idx: textPositions.count, textContent: returnTimeStr.description, point: CGPoint(x: insideRectWidth / 2, y: insideHeight / 2), frameSize: CGSize(width: 120, height: 50), textSize: 15, boldCharacterBool: false, italicBool: false, underlineBool: false, degree: 0))
                    returnTimeStr = "1"
                    print("改動後的數值：", textPositions.last!)
                  }
                }
              case 3:
                NavigationLink(isActive: $createDatePageBool) {
                  CreateTimeText(finalDate: $returnTimeStr, popBool: $createDatePageBool)
                } label: {
                  Image(systemName: imageNameArray[idxNum])
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                }
                .onAppear {
                  // TODO: 製造一個Text 是日期
                  print("日期製造器")
                  if returnTimeStr != "1" {
                    textPositions.append(TextIdxType(idx: textPositions.count, textContent: returnTimeStr.description, point: CGPoint(x: insideRectWidth / 2, y: insideHeight / 2), frameSize: CGSize(width: 120, height: 50), textSize: 15, boldCharacterBool: false, italicBool: false, underlineBool: false, degree: 0))
                    returnTimeStr = "1"
                    print("改動後的數值：", textPositions.last!)
                  }
                }

              default:
                Image(systemName: imageNameArray[idxNum])
                  .font(.system(size: 40, weight: .medium, design: .rounded))
                  .foregroundColor(.white)
              }
            }
          }
        }
        .background(Color.blue)
      }
      .frame(height: 80)
      Color.black
        .frame(height: bottomSafeAreaHeight)
    }
    // 點擊回傳點擊位置，回傳的是最外層的數值，要經過處理才是框框裡的數值
    .gesture(drag)
    .background(Color.black)
    .edgesIgnoringSafeArea(.all)
    .onAppear {
      print("load page~~~~~~~~~~~")
    }
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
    let insideHeight = insideRectWidth * ratio
    RoundedRectangle(cornerRadius: 0, style: .continuous)
      .frame(width: insideRectWidth, height: insideHeight, alignment: .top)
      .foregroundColor(Color.white)
      .overlay(
        ZStack {
          ForEach(textPositions.indices, id: \.self) { index in
            // $activeIdx 代表 activeIdx 會隨 editingText變動。
            EditingText(activeText: $activeIdx, label: textPositions[index].textContent, idx: textPositions[index].idx, underlineBool: textPositions[index].underlineBool)
              .frame(width: textPositions[index].frameSize.width, height: textPositions[index].frameSize.height)
              .position(textPositions[index].point)
              .font(textPositions[index].boldCharacterBool ? textPositions[index].italicBool ? .system(size: textPositions[index].textSize).bold().italic() : .system(size: textPositions[index].textSize).bold() : textPositions[index].italicBool ? .system(size: textPositions[index].textSize).italic() : .system(size: textPositions[index].textSize))

            // 旋轉後移動會跟著旋轉，暫無法使用
//              .rotationEffect(.degrees(textPositions[index].degree))
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
              showView = verticalAmount < 0
            }
          })
      Text("Setting")
        .lineLimit(1)
        .foregroundColor(.black)
        .frame(height: 40)
      HStack(spacing: 10) {
        Button {
          let sizeNum = textPositions[activeIdx].textSize
          textPositions[activeIdx].textSize = sizeNum + 1
        } label: {
          Image(systemName: "plus.magnifyingglass")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        Button {
          let sizeNum = textPositions[activeIdx].textSize
          if sizeNum > 0 {
            textPositions[activeIdx].textSize = sizeNum - 1
          }
        } label: {
          Image(systemName: "minus.magnifyingglass")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        Button {
          let bool = textPositions[activeIdx].boldCharacterBool
          textPositions[activeIdx].boldCharacterBool = !bool
        } label: {
          Image(systemName: "bold")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        Button {
          let bool = textPositions[activeIdx].italicBool
          textPositions[activeIdx].italicBool = !bool
        } label: {
          Image(systemName: "italic")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        Button {
          let bool = textPositions[activeIdx].underlineBool
          textPositions[activeIdx].underlineBool = !bool
        } label: {
          Image(systemName: "underline")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        Button {
          popoverBool = true
        } label: {
          Image(systemName: "pencil.circle")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        .popover(isPresented: $popoverBool) {
          VStack(spacing: 30) {
            HStack {
              TextField("EditTextField", text: $textPositions[activeIdx].textContent)
                .font(.system(size: 18))
                .foregroundColor(.black)
                .frame(width: 300)
                .textFieldStyle(.roundedBorder)
            }
            Button {
              popoverBool = false
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
    .position(x: UIScreen.main.bounds.width / 2, y: offsetY)
  }
}

// MARK: - others struct

struct EditingText: View {
  @Binding var activeText: Int
  let label: String
  let idx: Int
  var underlineBool: Bool

  var body: some View {
    Text(label)
      .underline(underlineBool)
      .onTapGesture {
        print("idx ", idx, "; act ", activeText, ",", label)
        self.activeText = self.idx
        print("idx ", idx, "; act ", activeText, ",", label)
      }
      .background(EditingBorder(show: activeText == idx))
  }
}

struct EditingBorder: View {
  let show: Bool
  var body: some View {
    RoundedRectangle(cornerRadius: 3)
      .stroke(lineWidth: 2)
      .foregroundColor(show ? Color.red : Color.clear)
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
