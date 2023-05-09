//
//  DataModel.swift
//  Checklists
//
//  Created by Hong Duc on 05/05/2023.
//  Copyright © 2023 Hong Duc. All rights reserved.
//

import Foundation

class DataModel {
  var lists = [Checklist]()
  
  init() {
    loadChecklists()
    registerDefaults()
    handleFirstTime()
  }
  
  var indexOfSelectedChecklist: Int {
    get {
      return UserDefaults.standard.integer(forKey: "ChecklistIndex")
    }
    
    set {
      UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
      UserDefaults.standard.synchronize()
    }
  }
    
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    return paths[0]
  }
  
  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklists.plist")
  }
  
  func saveChecklists() {
    let encoder = PropertyListEncoder()
    
    do {
      let data = try encoder.encode(lists)
      
      print("Prepare write file")
      try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
      print("Write to file successful!")
      
//      if let data = try? Data(contentsOf: dataFilePath()) {
//        print("is file exist? \(data) at \(dataFilePath())")
//      } else {
//        print("file is not existed")
//      }
    } catch {
      print("Error encoding list: \(error.localizedDescription)")
    }
  }
  
  func loadChecklists() {
    let path = dataFilePath()
    
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        lists = try decoder.decode([Checklist].self, from: data)
        sortChecklists()
      } catch {
        print("Error decoding list array: \(error.localizedDescription)")
      }
    }
  }
  
  func registerDefaults() {
    let dict = ["ChecklistIndex": -1, "FirstTime": true] as [String : Any]
    UserDefaults.standard.register(defaults: dict)
  }
  
  func handleFirstTime() {
    let userDefaults = UserDefaults.standard
    let firstTime = userDefaults.bool(forKey: "FirstTime")
    
    if firstTime {
      let checklist = Checklist(name: "My First Checklist")
      lists.append(checklist)
      
      indexOfSelectedChecklist = 0
      userDefaults.set(false, forKey: "FirstTime")
      userDefaults.synchronize()
    }
  }
  
  func sortChecklists() {
    lists.sort(by: {list1, list2 in return list1.name.localizedStandardCompare(list2.name) == .orderedAscending})
  }
  
  class func nextChecklistItem() -> Int {
    let userDefaults = UserDefaults.standard
    let itemID = userDefaults.integer(forKey: "ChecklistItemID")
    userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
    userDefaults.synchronize()
    return itemID
  }
}
