//
//  Book.swift
//  ReadMe
//
//  Created by TakHyun Jung on 2020/11/27.
//

import UIKit

struct Book {
    let title: String
    let author: String
    var image: UIImage {
        Library.loadImage(forBook: self) ?? LibrarySymbol.letterSquare(letter: title.first).image
    }
}
