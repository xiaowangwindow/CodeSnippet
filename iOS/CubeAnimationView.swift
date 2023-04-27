import SwiftUI

struct DiceView: View {
    let screenWidth = UIScreen.main.bounds.width
    let cubeWidth: CGFloat = 200
    
    private struct ColorModel: Identifiable {
        let colorList: [Color]
        let id = UUID().uuidString
    }
    private let colorList: [Color] = [
        .green, .red, .blue, .yellow, .green, .red,
    ]

    @State private var degress = 0.0
    @State private var selectedPage = 0
    var body: some View {
        VStack {
            TabView(selection: $selectedPage)  {
                ForEach(Array(colorList.enumerated()), id: \.offset) { index, color in
                    GeometryReader { g in
                        VStack {
                            Spacer()
                            color.frame(height: 200)
                            Spacer()
                        }
                        .frame(width: g.frame(in: .global).width, height: g.frame(in: .global).height)
                        .rotation3DEffect(
                            .init(degrees: getAngle(index: index, xOffset: g.frame(in: .global).minX)),
                            axis: (x: 0, y: 1, z: 0),
                            anchor: getAnchor(index: index, xOffset: g.frame(in: .global).minX),
                            perspective: 5)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(width: self.cubeWidth)
            
            HStack {
                Button("<") {
                    var delay: CGFloat = 0
                    for i in 1...9 {
                        
                        let duration = CGFloat(i) * 0.1
                        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(Int(delay*1000))) {
                            
                            self.resetSelectedPage()
                            if selectedPage > 0 {
                                print(selectedPage)
                                withAnimation(.linear(duration: Double(duration))) {
                                    selectedPage -= 1
                                }
                            }
                        }
                        delay += duration
                        print(delay)
                    }
                }
                Spacer().frame(width: 50)
                Button(">") {
                    self.resetSelectedPage()
                    if selectedPage < self.colorList.count - 1 {
                    print(selectedPage)
                    withAnimation {
                        selectedPage += 1
                    }
                }}
            }
        }
        
    }
    
    func resetSelectedPage() {
        if selectedPage == self.colorList.count - 1 {
            selectedPage = 1
        } else if selectedPage == 0 {
            selectedPage = self.colorList.count - 2
        }
    }

    func getAngle(index: Int, xOffset: CGFloat) -> Double {
        let padding = (self.screenWidth - self.cubeWidth) / 2
        let offset = xOffset - padding
        print(index, xOffset, offset)
        let tempAngle = offset / (self.cubeWidth / 2)
        let rotationDegree: CGFloat = 20
        return Double(rotationDegree * tempAngle)
    }
    
    func getAnchor(index: Int, xOffset: CGFloat)-> UnitPoint {
        let padding = (self.screenWidth - self.cubeWidth) / 2
        let offset = xOffset - padding
        return offset > 0 ? .leading : .trailing
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView()
    }
}