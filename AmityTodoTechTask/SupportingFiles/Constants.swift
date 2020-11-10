//
//  Constants.swift
//  AmityTodoTechTask
//
//  Created by Kamran Usmani on 10/11/20.
//  Copyright © 2020 Amity. All rights reserved.
//

import Foundation

//MARK: - URL
struct Endpoint {
    // change json file endpoint here.
    static let jsonURL = "https://gist.githubusercontent.com/nRewik/c72c08e6044940c970b742cc13066f4c/raw/e2de4a30232c161abbd3fde69cce405f2e335f89/todos_1k_and_users_50.json"
}

struct Const {
    static let limitMsg = "Data size is more than 500MB"
    static let sizeLimit = 524288000
}


extension Data {
func sizeString(units: ByteCountFormatter.Units = [.useAll], countStyle: ByteCountFormatter.CountStyle = .file) -> String {
    let bcf = ByteCountFormatter()
    bcf.allowedUnits = units
    bcf.countStyle = .file

    return bcf.string(fromByteCount: Int64(count))
 }}
