//
//  ComponentsSettingViews.swift
//  ios_edit_label
//
//  Created by sw_user03 on 2022/9/20.
//

// MARK: 編輯頁面的各種設定View

import SwiftUI

// MARK: 產生線條、方形等圖形

struct CreateNewRectView: View {
  @Binding var b_isShowing: Bool
  @Binding var b_componentsArr: [ComponentsIdxType]
  var mOffsetY: CGFloat

  var body: some View {
    let ratio: CGFloat = 3/4
    let insideRectWidth: CGFloat = UIScreen.main.bounds.width - 18
    let insideRectHeight = insideRectWidth * ratio
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
              print(horizontalAmount < 0 ? "left swipe":"right swipe")
            } else {
              print(verticalAmount < 0 ? "up swipe":"down swipe")
              b_isShowing = verticalAmount < 0
            }
          })
      Text("新增圖示")
        .lineLimit(1)
        .foregroundColor(Color("NormalRed"))
        .frame(height: 40)
        .font(Font.system(Font.TextStyle.title3))
      HStack(spacing: 10) {
        // 直線
        Button {
          b_componentsArr.append(ComponentsIdxType(
            idx: b_componentsArr.count,
            componentType: ComponentTypeEnum.line.rawValue,
            point: CGPoint(x: insideRectWidth/2, y: insideRectHeight/2),
            frameSize: CGSize(width: 100, height: 30),
            degree: 0,
            textContent: "Line",
            textSize: 15,
            textIsBold: false,
            textIsItalic: false,
            textIsUnderline: false,
            rectLineWidth: 2,
            pathPoint: CGPoint(x: 0, y: 15),
            rectIsDash: false,
            rectDashLength: 5,
            rectCornerRadius: 0)
          )
        } label: {
          Image(systemName: "line.diagonal")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        
        // 長方形
        Button {
          b_componentsArr.append(ComponentsIdxType(
            idx: b_componentsArr.count,
            componentType: ComponentTypeEnum.rectangle.rawValue,
            point: CGPoint(x: insideRectWidth/2, y: insideRectHeight/2),
            frameSize: CGSize(width: 100, height: 60),
            degree: 0,
            textContent: "Rect",
            textSize: 15,
            textIsBold: false,
            textIsItalic: false,
            textIsUnderline: false,
            rectLineWidth: 2,
            pathPoint: CGPoint(),
            rectIsDash: false,
            rectDashLength: 5,
            rectCornerRadius: 0)
          )
        } label: {
          Rectangle()
            .inset(by: 1)
            .stroke(lineWidth: 2)
            .frame(width: 35, height: 25)
        }
        // 圓角長方形
        Button {
          b_componentsArr.append(ComponentsIdxType(
            idx: b_componentsArr.count,
            componentType: ComponentTypeEnum.roundedRectangle.rawValue,
            point: CGPoint(x: insideRectWidth/2, y: insideRectHeight/2),
            frameSize: CGSize(width: 100, height: 60),
            degree: 0,
            textContent: "Rounded",
            textSize: 15,
            textIsBold: false,
            textIsItalic: false,
            textIsUnderline: false,
            rectLineWidth: 2,
            pathPoint: CGPoint(),
            rectIsDash: false,
            rectDashLength: 5,
            rectCornerRadius: 5)
          )
        } label: {
          Image(systemName: "rectangle")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        // 圓圈
        Button {
          b_componentsArr.append(ComponentsIdxType(
            idx: b_componentsArr.count,
            componentType: ComponentTypeEnum.circle.rawValue,
            point: CGPoint(x: insideRectWidth/2, y: insideRectHeight/2),
            frameSize: CGSize(width: 100, height: 100),
            degree: 0,
            textContent: "Circle",
            textSize: 15,
            textIsBold: false,
            textIsItalic: false,
            textIsUnderline: false,
            rectLineWidth: 2,
            pathPoint: CGPoint(),
            rectIsDash: false,
            rectDashLength: 5,
            rectCornerRadius: 0)
          )
        } label: {
          Image(systemName: "circle")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
        // 橢圓
        Button {
          let frameWidth: CGFloat = 100
          let frameHeight: CGFloat = 60
          b_componentsArr.append(ComponentsIdxType(
            idx: b_componentsArr.count,
            componentType: ComponentTypeEnum.oval.rawValue,
            point: CGPoint(x: insideRectWidth/2, y: insideRectHeight/2),
            frameSize: CGSize(width: frameWidth, height: frameHeight),
            degree: 0,
            textContent: "Oval",
            textSize: 15,
            textIsBold: false,
            textIsItalic: false,
            textIsUnderline: false,
            rectLineWidth: 2,
            pathPoint: CGPoint(),
            rectIsDash: false,
            rectDashLength: 5,
            rectCornerRadius: 0)
          )
        } label: {
          Image(systemName: "oval")
            .font(.system(size: 30))
            .frame(width: 35, height: 35)
        }
      }
      Color.gray
        .frame(height: 120)
    }
    .frame(minWidth: 0, maxWidth: .infinity)
    .background(Color.gray)
    .cornerRadius(30)
    .shadow(radius: 20)
    // 上下移動的變量
    .position(x: UIScreen.main.bounds.width/2, y: mOffsetY)
  }
}

// MARK: 控制圖形粗細、圓角等
struct ControlComponentsView: View {
  @Binding var b_isShow: Bool
  @Binding var b_componentsArr: [ComponentsIdxType]
  var mActiveIdx: Int

  var body: some View {
    if b_isShow {
      VStack(spacing: 5) {
        HStack {
          Spacer()
            .frame(width: 40, height: 40)
          Spacer()
          Text("控制")
            .lineLimit(1)
            .foregroundColor(Color("NormalRed"))
            .frame(height: 40)
            .font(Font.system(Font.TextStyle.title3))
          Spacer()
          Button {
            b_isShow = false
          } label: {
            Image(systemName: "x.circle.fill")
              .foregroundColor(Color("LightGray"))
          }
          .frame(width: 40, height: 40)
        }
        HStack {
          HStack {
            Text("線寬")
              .foregroundColor(Color("LightGray"))
              .padding()
            Button {
              if mActiveIdx >= 0 {
                b_componentsArr[mActiveIdx].rectLineWidth += 1
              }
            } label: {
              Image(systemName: "plus.circle")
                .padding(5)
            }
            Text(b_componentsArr.count > 0 && mActiveIdx >= 0 ? "\(Int(b_componentsArr[mActiveIdx].rectLineWidth))":"0")
            Button {
              if mActiveIdx >= 0 {
                if b_componentsArr[mActiveIdx].rectLineWidth > 1 {
                  b_componentsArr[mActiveIdx].rectLineWidth -= 1
                }
              }
            } label: {
              Image(systemName: "minus.circle")
                .padding(5)
                .padding(.trailing, 10)
            }
          }
          .background(
            RoundedRectangle(cornerRadius: 20)
              .inset(by: 3)
              .stroke(Color("LightGray"), style: StrokeStyle(lineWidth: 1, lineCap: .round))
          )
          HStack {
            Spacer()
            Toggle(isOn: b_componentsArr.count > 0 && mActiveIdx >= 0 ? $b_componentsArr[mActiveIdx].rectIsDash:.constant(false)) {
              Text("虛線")
                .foregroundColor(Color("LightGray"))
                .padding()
            }
            .padding(.trailing, 10)
          }
          .background(
            RoundedRectangle(cornerRadius: 20)
              .inset(by: 3)
              .stroke(Color("LightGray"), style: StrokeStyle(lineWidth: 1, lineCap: .round))
          )
        }
        HStack {
          Text("寬：")
            .foregroundColor(Color("LightGray"))
            .padding(.leading, 15)
          Text(b_componentsArr.count > 0 && mActiveIdx >= 0 ? "\(Int(b_componentsArr[mActiveIdx].frameSize.width))":"0")
            .frame(width: 60)
          Spacer()
          Slider(value: b_componentsArr.count > 0 && mActiveIdx >= 0 ? $b_componentsArr[mActiveIdx].frameSize.width:.constant(0), in: 0...500)
            .padding(.trailing, 10)
        }
        HStack {
          Text("高：")
            .foregroundColor(Color("LightGray"))
            .padding(.leading, 15)
          Text(b_componentsArr.count > 0 && mActiveIdx >= 0 ? "\(Int(b_componentsArr[mActiveIdx].frameSize.height))":"0")
            .frame(width: 60)
          Spacer()
          Slider(value: b_componentsArr.count > 0 && mActiveIdx >= 0 ? $b_componentsArr[mActiveIdx].frameSize.height:.constant(0), in: 0...500)
            .padding(.trailing, 10)
        }
        HStack {
          Text("圓角數值：")
            .foregroundColor(Color("LightGray"))
            .padding()
          Text(b_componentsArr.count > 0 && mActiveIdx >= 0 ? "\(Int(b_componentsArr[mActiveIdx].rectCornerRadius))":"0")
            .frame(width: 60)
          Spacer()
          Slider(value: b_componentsArr.count > 0 && mActiveIdx >= 0 ? $b_componentsArr[mActiveIdx].rectCornerRadius:.constant(0), in: 0...30, label: {
            Text("title")
          }, minimumValueLabel: {
            Text("0")
              .foregroundColor(Color("LightGray"))
          }, maximumValueLabel: {
            Text("30")
              .foregroundColor(Color("LightGray"))
          })
          .padding()
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity)
      .background(Color("DeepLogoGreen"))
      .cornerRadius(20)
      .shadow(radius: 20)
    }
  }
}
