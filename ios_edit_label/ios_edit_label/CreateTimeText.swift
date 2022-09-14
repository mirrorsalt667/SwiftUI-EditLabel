//
//  CreateTimeText.swift
//  ios_edit_label
//
//  Created by sw_user03 on 2022/9/14.
//

import SwiftUI

struct CreateTimeText: View {
  
//  @Environment(\.presentationMode) var pushMode
  @Binding var finalDate: String
  @Binding var popBool: Bool
  
  struct TimeFormat {
    let frontDateFormat: String
    let hourFormat: String
  }

  private let translateFormat: [TimeFormat] = [TimeFormat(frontDateFormat: "yyyy-MM-dd", hourFormat: "HH:mm"), TimeFormat(frontDateFormat: "yyyy-MM-dd", hourFormat: ""), TimeFormat(frontDateFormat: "MM-dd", hourFormat: "HH:mm"), TimeFormat(frontDateFormat: "MM-dd", hourFormat: ""), TimeFormat(frontDateFormat: "", hourFormat: "HH:mm")]
  @State private var selectedFormat = TimeFormat(frontDateFormat: "yyyy-MM-dd", hourFormat: "HH:mm")
  @State private var selectedDate = Date()
  @State private var selectedHour = Date()

  var body: some View {
    // 取得上、下安全範圍的高度
    let topSafeAreaHeight = getSafeAreaTop()
    let bottomSafeAreaHeight = getSafeAreaBottom()
    let navigationHeght: CGFloat = 50 // 暫定為50

    VStack {
      // safe area 填入黑色
      Color.black
        .frame(height: topSafeAreaHeight + navigationHeght)
      HStack {
        Color.black.frame(width: 15)
        Color.white
          .overlay(
            VStack {
              Text("預覽").frame(height: 30)
              Text(changeDateFormat(format: selectedFormat, inputDate: selectedDate, inputHour: selectedHour))
                .foregroundColor(.black)
                .font(Font.system(size: 24, weight: .regular, design: .default))
            }
          )
        Color.black.frame(width: 15)
      }
      VStack(spacing: 10) {
        Text("請選擇日期")
          .foregroundColor(Color("TiffanyBlue"))
          .padding(.top, 10)
        VStack(spacing: 0) {
          DatePicker("time picker", selection: $selectedDate, displayedComponents: .date)
            .labelsHidden()
            .datePickerStyle(.wheel)
            .environment(\.locale, .init(identifier: "zh-tw"))
            .colorInvert()
            .colorMultiply(Color.white)
            .background(
              // Color("LogoGreen")
              Color.black
            )
          DatePicker("time picker", selection: $selectedHour, displayedComponents: .hourAndMinute)
            .labelsHidden()
            .datePickerStyle(.automatic)
            .environment(\.locale, .init(identifier: "zh-han"))
            .colorInvert()
            .colorMultiply(Color.white)
            .background(
              // Color("NormalRed")
              Color.black
            )
            .padding(.bottom, 10)
        }
      }
      .border(Color("NormalRed"), width: 2)
      Text("請選擇一種日期格式")
        .foregroundColor(.white)
        .padding(.top, 15)
      ScrollView(.vertical) {
        LazyVStack {
          ForEach(0 ..< translateFormat.count, id: \.self) { idx in
            Button {
              selectedFormat = translateFormat[idx]
            } label: {
              HStack(spacing: 5) {
                Color.clear.frame(width: 20)
                Text(translateFormat[idx].frontDateFormat + translateFormat[idx].hourFormat)
                  .foregroundColor(Color("Green"))
                Color.clear
              }
            }
          }
        }
      }
      Button {
        // TODO: 回傳資料
        finalDate = changeDateFormat(format: selectedFormat, inputDate: selectedDate, inputHour: selectedHour)
        popBool = false
//        pushMode.wrappedValue.dismiss()
      } label: {
        Text("確認")
          .foregroundColor(Color.black)
      }
      .frame(width: 160, height: 50)
      .background(
        RoundedRectangle(cornerRadius: 18)
          .frame(width: 160, height: 50)
          .foregroundColor(Color("LightGray"))
      )
      // safe area 填入黑色
      Color.black
        .frame(height: bottomSafeAreaHeight)
    }
    .background(Color.black)
    .edgesIgnoringSafeArea(.all)
  }

  // MARK: - Function

  private func changeDateFormat(format: TimeFormat, inputDate: Date, inputHour: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.frontDateFormat
    let hourFormatter = DateFormatter()
    hourFormatter.dateFormat = format.hourFormat
    let dateStr = dateFormatter.string(from: inputDate)
    let hourStr = hourFormatter.string(from: inputHour)
    return dateStr + " " + hourStr
  }

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

struct CreateTimeText_Previews: PreviewProvider {
  static var previews: some View {
    CreateTimeText(finalDate: .constant("2022-09-14 23:45"), popBool: .constant(false))
  }
}
