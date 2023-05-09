import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
  var text = ""
  var checked = false
  var dueDate = Date()
  var shouldRemind = false
  
  /// Notification unique identifier
  var itemID = -1
  
  override init() {
    super.init()
    itemID = DataModel.nextChecklistItem()
  }
  
  deinit {
    print("Checklist \(itemID) deinitialized!")
    removeNotification()
  }
  
  func toggleChecked() {
    checked = !checked
  }
  
  func scheduleNotification() {
    removeNotification()
    if shouldRemind && dueDate > Date() {
      print("Should schedule a notification!")
      
      // Instantiate Notification's content
      let content = UNMutableNotificationContent()
      content.title = "Reminder:"
      content.body = text
      content.sound = .default
      
      // Extract date components from due date.
      let calendar = Calendar(identifier: .gregorian)
      let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
      
      
      let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
      
      let request = UNNotificationRequest(
        identifier: "\(itemID)", content: content, trigger: trigger)
      
      let center = UNUserNotificationCenter.current()
      center.add(request)
      
      print("Scheduled: \(request) for item ID: \(itemID)")
    }
  }
  
  func removeNotification() {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
  }
}
