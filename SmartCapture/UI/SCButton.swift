import SwiftUI

struct SCButton: View {
    private let action: () -> Void
    let title: String
    let backgroundColor: Color
    
    init(
        action: @escaping () -> Void,
        title: String,
        foregroundColor: Color
    ) {
        self.action = action
        self.title = title
        self.backgroundColor = foregroundColor
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(backgroundColor)
                .cornerRadius(10)
        })
    }
}
