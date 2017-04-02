//
//  Issue.swift
//  IssueViewer
//
//  Created by Michael Le on 02/04/2017.
//  Copyright © 2017 Michael Le. All rights reserved.
//

import Foundation
import Mapper

struct Issue: Mappable {
  let identifier: Int
  let number: Int
  let title: String
  let body: String
  
  init(map: Mapper) throws {
    try identifier = map.from("id")
    try number = map.from("number")
    try title = map.from("title")
    try body = map.from("body")
  }
}
