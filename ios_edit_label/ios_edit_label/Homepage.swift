//
//  Homepage.swift
//  DemoLabelApp
//
//  Created by sw_user03 on 2022/8/30.
//

// MARK: 首頁

// Name Rules
// mName -> 該view內的全域變數、常數
// b_name -> 該物件中的Binding變數、常數



import SwiftUI

struct Homepage: View {
  private let mDeviceWidth = UIScreen.main.bounds.width
  private let mDeviceHeight = UIScreen.main.bounds.height
  private var mGridItemArray: [GridItem] = [GridItem(.flexible())]
  private let mGrid: [GridItem] = [
    GridItem(.fixed(150)),
    GridItem(.fixed(150)),
  ]
  private var mSymbols = ["list.bullet.rectangle", "camera", "circle.fill", "pencil", "square.fill", "moon", "arrow.right", "circle", "square"]
  
  var body: some View {
    // 取得上、下安全範圍的高度
    let topSafeAreaHeight = getSafeAreaTop()
    let bottomSafeAreaHeight = getSafeAreaBottom()
    // 加入NavigationView
    NavigationView {
      VStack {
        // safe area 填入黑色
        Color.black
          .frame(height: topSafeAreaHeight)
        // Gainscha 標誌
        Image("GainschaLogo")
          .frame(width: mDeviceWidth, height: mDeviceHeight / 4, alignment: .center)
          .background(Color.black)
        // 前往其他頁面的滑動軸
        ScrollView(.horizontal) {
          LazyHGrid(rows: mGridItemArray, spacing: 15) {
            ForEach(0 ..< mSymbols.count, id: \.self) {
              index in
              ZStack {
                Rectangle()
                  .frame(width: 130, height: 130)
                  .foregroundColor(Color("DeepLogoGreen"))
                switch index {
                case 0:
                  NavigationLink {
                    EditLabelPage()
                  } label: {
                    Image(systemName: mSymbols[index])
                      .font(.system(size: 40, weight: .medium, design: .rounded))
                      .foregroundColor(.white)
                  }
                case 1:
                  NavigationLink {
                    ContentView()
                  } label: {
                    Image(systemName: mSymbols[index])
                      .font(.system(size: 40, weight: .medium, design: .rounded))
                      .foregroundColor(.white)
                  }
                case 2:
                  NavigationLink {
                    ContentView()
                  } label: {
                    Image(systemName: mSymbols[index])
                      .font(.system(size: 40, weight: .medium, design: .rounded))
                      .foregroundColor(.white)
                  }
                case 3:
                  NavigationLink {
                    ContentView()
                  } label: {
                    Image(systemName: mSymbols[index])
                      .font(.system(size: 40, weight: .medium, design: .rounded))
                      .foregroundColor(.white)
                  }
                case 4:
                  NavigationLink {
//                    CreateTimeText(finalDate: .constant("1"), popBool: .constant(true))
                  } label: {
                    Image(systemName: mSymbols[index])
                      .font(.system(size: 40, weight: .medium, design: .rounded))
                      .foregroundColor(.white)
                  }
                default:
                  Image(systemName: mSymbols[index])
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                }
              }
            }
          }
        }
        // 三個並排的按鈕
        HStack(spacing: 15) {
          Button {
            // TODO: all
          } label: {
            Text("All")
          }
          .frame(width: 80, height: 30)
          .background(Rectangle()
            .foregroundColor(.black)
            .frame(width: 80, height: 30)
            .border(Color("NormalRed"), width: 2))
          Button {
            // TODO: recent
          } label: {
            Text("Recents")
              .fixedSize()
          }
          .frame(width: 90, height: 30)
          .background(Rectangle()
            .foregroundColor(.black)
            .frame(width: 90, height: 30)
            .border(Color("NormalRed"), width: 2))
          Button {
            // TODO: Add
          } label: {
            Text("Add")
          }
          .frame(width: 80, height: 30)
          .background(Rectangle()
            .foregroundColor(.black)
            .frame(width: 80, height: 30)
            .border(Color("NormalRed"), width: 2))
        }
        .padding()

        // 最近編輯及使用過的檔案及模板
        ScrollView(.vertical) {
          LazyVGrid(columns: mGrid, spacing: 15) {
            ForEach(mSymbols, id: \.self) { _ in
              Image(systemName: "moon")
                .foregroundColor(Color.white)
//                .resizable()
//                .scaledToFit()
                .frame(width: 150, height: 150)
                .border(Color.white, width: 2)
            }
          }
        }
        // 下面的 safe area 高度
        Color.black
          .frame(height: bottomSafeAreaHeight)
      }
      .navigationBarHidden(true)
      .background(Color.black)
      .edgesIgnoringSafeArea(.all)
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
}

// MARK: - Preview

struct Homepage_Previews: PreviewProvider {
  static var previews: some View {
    Homepage()
      .previewDevice(PreviewDevice(rawValue: "iPhone 11 pro"))
  }
}
