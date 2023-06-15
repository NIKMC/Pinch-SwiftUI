//
//  ControllImageView.swift
//  Pinch
//
//  Created by Ivan Nikitin on 14.06.2023.
//

import SwiftUI

struct ControllImageView: View {
    var icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 36))
    }
}

struct ControllImageView_Previews: PreviewProvider {
    static var previews: some View {
        ControllImageView(icon: "minus.magnifyingglass")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
