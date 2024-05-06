//
//  SegmentedProgressBar.swift
//  Shawa
//
//  Created by Alex on 4.05.24.
//

import SwiftUI

struct SegmentedProgressBar<EnumType: CaseIterable & Hashable>: View {
    var currentState: EnumType?
    var allCases = Array(EnumType.allCases)
    
    var unactiveColor = Color.init(uiColor: .systemBackground)
    var activeColor = Color.green
    var borderColor = Color.accentColor
    
    var caseTapped: (_ case: EnumType) -> Void = { _ in }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // границы для кругов и прогресса
                Capsule()
                    .stroke(lineWidth: .Constants.SegmentedProgressBar.borderWidth)
                    .frame(width: geometry.size.width, height: .Constants.SegmentedProgressBar.barHeight)
                    .foregroundStyle(borderColor)
                ForEach(allCases, id: \.self) { enumCase in
                    Circle()
                        .stroke(lineWidth: .Constants.SegmentedProgressBar.borderWidth)
                        .frame(width: .Constants.SegmentedProgressBar.circleHeight,
                               height: .Constants.SegmentedProgressBar.circleHeight)
                        .foregroundStyle(borderColor)
                        .position(
                            x: self.circlePosition(
                                index: allCases.firstIndex(of: enumCase)!,
                                totalWidth: geometry.size.width
                            ),
                            y: .Constants.SegmentedProgressBar.height / 2
                        )
                }
                // незакрашенная часть прогресса
                Capsule()
                    .frame(width: geometry.size.width, height: .Constants.SegmentedProgressBar.barHeight)
                    .foregroundStyle(unactiveColor)
                
                // закрашенная часть прогресса
                Capsule()
                    .frame(width: self.fillWidth(upTo: currentState, 
                                                 totalWidth: geometry.size.width),
                           height: .Constants.SegmentedProgressBar.barHeight)
                    .foregroundColor(activeColor)
                    .animation(.linear(duration: 1), value: currentState)
                
                // круги, встроенные в полосу
                ForEach(allCases, id: \.self) { enumCase in
                    Circle()
                        .frame(width: .Constants.SegmentedProgressBar.circleHeight,
                               height: .Constants.SegmentedProgressBar.circleHeight)
                        .foregroundStyle(self.circleColor(for: enumCase))
                        .position(
                            x: self.circlePosition(
                                index: allCases.firstIndex(of: enumCase)!,
                                totalWidth: geometry.size.width
                            ),
                            y: .Constants.SegmentedProgressBar.height / 2
                        )
                        .animation(.linear(duration: 0.1).delay(1), value: currentState)
                    
                    Button {
                        caseTapped(enumCase)
                    } label: {
                        Circle()
                            .frame(width: .Constants.SegmentedProgressBar.height,
                                   height: .Constants.SegmentedProgressBar.height)
                            .foregroundStyle(.clear)
                    }
                    .position(
                        x: self.circlePosition(
                            index: allCases.firstIndex(of: enumCase)!,
                            totalWidth: geometry.size.width
                        ),
                        y: .Constants.SegmentedProgressBar.height / 2
                    )
                }
            }
        }.frame(height: .Constants.SegmentedProgressBar.height)
    }
    
    private func circlePosition(index: Int, totalWidth: CGFloat) -> CGFloat {
        let stepWidth = totalWidth / CGFloat(allCases.count)
        return stepWidth * CGFloat(index) + stepWidth / 2
    }

    private func fillWidth(upTo state: EnumType?, totalWidth: CGFloat) -> CGFloat {
        guard let state = state else { return 0 }
        guard let currentIndex = allCases.firstIndex(of: state) else { return 0 }
        let stepWidth = totalWidth / CGFloat(allCases.count)
        if allCases.firstIndex(of: state) == allCases.endIndex.advanced(by: -1) {
            return totalWidth
        }
        return stepWidth * CGFloat(currentIndex) + stepWidth / 2
    }

    private func circleColor(for state: EnumType) -> Color {
        guard let currentState = currentState,
              let currentIndex = allCases.firstIndex(of: currentState),
              let stateIndex = allCases.firstIndex(of: state),
              stateIndex <= currentIndex else {
            return unactiveColor
        }
        return activeColor
    }
}




#Preview {
    enum ProgressState: String, CaseIterable {
        case stepOne
        case stepTwo
        case stepThree
        case stepFour
    }
    
    struct Prev: View {
        @State var currentState: ProgressState? = .stepOne
        
        var body: some View {
            SegmentedProgressBar(currentState: currentState) { c in
                currentState = c
            }
            .background(.red)
        }
    }
    
    return Prev()
}
