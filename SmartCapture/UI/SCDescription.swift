import SwiftUI

struct SCDescription: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}
