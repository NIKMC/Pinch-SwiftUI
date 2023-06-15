//
//  PageModel.swift
//  Pinch
//
//  Created by Ivan Nikitin on 15.06.2023.
//

import Foundation

struct Page: Equatable, Identifiable {
    let id: Int
    let imageName: String
    var ID: UUID = .init()
    
    init(id: Int,
         imageName: String,
         ID: UUID = .init()) {
        self.id = id
        self.imageName = imageName
        self.ID = ID
    }
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
