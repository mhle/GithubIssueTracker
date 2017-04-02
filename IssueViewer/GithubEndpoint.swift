//
//  GithubEndpoint.swift
//  IssueViewer
//
//  Created by Michael Le on 02/04/2017.
//  Copyright © 2017 Michael Le. All rights reserved.
//

import Foundation
import Moya

private extension String {
  var URLEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
  }
}

enum Github {
  case userProfile(username: String)
  case repos(username: String)
  case repo(fullName: String)
  case issues(repositoryFullname: String)
}

extension Github: TargetType {
  var baseURL: URL { return URL(string: "https://api.github.com")! }
  
  var path: String {
    switch self {
    case .repos(let name):
      return "/users/\(name.URLEscapedString)/repos"
    case .userProfile(let name):
      return "/users/\(name.URLEscapedString)"
    case .repo(let name):
      return "/repos/\(name)"
    case .issues(let repositoryName):
      return "/repos/\(repositoryName)/issues"
    }
  }
  
  var method: Moya.Method {
    return .get
  }
  
  var parameters: [String: Any]? {
    return nil
  }
  
  var sampleData: Data {
    switch self {
    case .repos(_):
      return "{{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/testuser/FooProject\", \"name\": \"FooProject\"}}}".data(using: .utf8)!
    case .userProfile(let name):
      return "{\"login\": \"\(name)\", \"id\": 100}".data(using: .utf8)!
    case .repo(_):
      return "{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/testuser/FooProject\", \"name\": \"FooProject\"}".data(using: .utf8)!
    case .issues(_):
      return "{\"id\": 132942471, \"number\": 405, \"title\": \"There is a bug where foo is returning bar instead of foobar\", \"body\": \"Fix it pls.\"}".data(using: .utf8)!
    }
  }
  
  var task: Task {
    return .request
  }
  
  var parameterEncoding: ParameterEncoding {
    return JSONEncoding.default
  }
}
