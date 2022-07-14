/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import RemoteImageView

struct SpinningPenView: View {
  @State var rotationAmount = 0.0
  @State var numberOfSegments = 6.0
  
  @ObservedObject var settingsStore = SettingsStore()
  
  func nextRotationAmount() -> Double {
    // Choose the next person
    let destinedPerson = Int.random(in: 1...Int(numberOfSegments))
    
    // Determine how much to rotate the pen back to the top
    let numberOfPreviousRotations = ceil(rotationAmount / 360)
    let nextCompleteRotation = numberOfPreviousRotations * 360
    let resetToTop = nextCompleteRotation - rotationAmount
    
    // Determine how far around the circle the pen should stop
    let segmentArc = 360 / numberOfSegments;
    let finishingPosition = Double((destinedPerson - 1)) * segmentArc
    
    // Spin at least 5 times
    let minSpin: Double = 360 * 5
    
    return resetToTop + minSpin + finishingPosition
  }
  
  var body: some View {
    return VStack {
      Button(action: {
        withAnimation(.spring(response:1.25, dampingFraction:3.0, blendDuration:0.5)) {
          self.rotationAmount += self.nextRotationAmount()
        }
      }) {
        Image("sharpie")
          .resizable()
          .scaledToFit()
      }
      .buttonStyle(PlainButtonStyle())
      .rotation3DEffect(.degrees(rotationAmount), axis: (x: 0, y: 0, z: 1))
      VStack {
        Slider(
          value: $numberOfSegments,
          in: 2...12,
          step: 1.0
        )
        Text("Select destiny between \(numberOfSegments, specifier: "%.f") people.")
      }
    }
    .navigationBarTitle("Pen of Destiny", displayMode: .large)
    .navigationBarItems(trailing:
      NavigationLink(destination: SettingsView(settingsStore: settingsStore)) {
        Image(systemName: "gear")
      }
    )
      .padding(.all)
  }
}

#if DEBUG
struct SpinningPenView_Previews: PreviewProvider {
  static var previews: some View {
    SpinningPenView()
  }
}
#endif
