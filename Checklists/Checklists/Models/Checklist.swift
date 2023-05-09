import UIKit

class Checklist: NSObject, Codable {
  var name = ""
  var items = [ChecklistItem]()
  var iconName: String
  
  init(name: String, iconName: String = "No Icon") {
    self.name = name
    self.iconName = iconName
    super.init()
  }
  
  func countUncheckedItems() -> Int {
    var count = 0
    for item in items where !item.checked {
      count += 1
    }
    
    return count
  }
}

//func saveChecklistItems() {
//  let encoder = PropertyListEncoder()
//  do {
//    let data = try encoder.encode(checklist.items)
//    try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
//  } catch {
//    print("Error encoding item array: \(error.localizedDescription)")
//  }
//}
// func loadChecklistItems() {
//let path = dataFilePath()
//if let data = try? Data(contentsOf: path) {
//  let decoder = PropertyListDecoder()
//  do {
//    checklist.items = try decoder.decode([ChecklistItem].self, from: data)
//  } catch {
//    print("Error decoding item array: \(error.localizedDescription)")
//  }
//}
//}
