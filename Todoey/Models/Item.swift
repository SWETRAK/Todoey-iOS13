//
//  TaskModel.swift
//  Todoey
//
//  Created by Kamil Pietrak on 08/03/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct Item: Encodable, Decodable{
    
    var title: String
    var done: Bool = false
    
}
