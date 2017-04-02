//
//  Repository.swift
//  IssueViewer
//
//  Created by Michael Le on 02/04/2017.
//  Copyright © 2017 Michael Le. All rights reserved.
//

import Foundation
import Mapper

struct Repository: Mappable {
  let identifier: Int
  let language: String
  let name: String
  let fullName: String
  
  init(map: Mapper) throws {
    try identifier = map.from("id")
    try language = map.from("language")
    try name = map.from("name")
    try fullName = map.from("full_name")
  }
}
