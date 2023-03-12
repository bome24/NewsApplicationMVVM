//
//  Article.swift
//  GoodNewsMVVM
//
//  Created by BoMin on 2023/03/12.
//

import Foundation

struct ArticlesList: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    let description: String?
}
