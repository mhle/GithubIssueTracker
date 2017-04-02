//
//  IssueTrackerModel.swift
//  IssueViewer
//
//  Created by Michael Le on 02/04/2017.
//  Copyright © 2017 Michael Le. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxOptional
import Mapper
import Moya_ModelMapper

struct IssueTrackerModel {
  let provider: RxMoyaProvider<Github>
  let repositoryName: Observable<String>
  
  func trackIssues() -> Observable<[Issue]> {
    return repositoryName
      .observeOn(MainScheduler.instance)
      .flatMapLatest { name -> Observable<Repository?> in
        print("Name: \(name)")
        return self.findRepository(withName: name)
      }
      .flatMapLatest { repository -> Observable<[Issue]?> in
        guard let repository = repository else { return Observable.just(nil) }
        
        print("Repository: \(repository.fullName)")
        return self.findIssues(for: repository)
      }
      .replaceNilWith([])
  }
  
  internal func findIssues(for repository: Repository) -> Observable<[Issue]?> {
    return provider
      .request(Github.issues(repositoryFullname: repository.fullName))
      .debug()
      .mapArrayOptional(type: Issue.self)
  }
  
  internal func findRepository(withName name: String) -> Observable<Repository?> {
    return provider
      .request(Github.repo(fullName: name))
      .debug()
      .mapObjectOptional(type: Repository.self)
  }
}
