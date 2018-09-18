import Vapor
import FluentSQLite

final class Review: Content {
  var id: Int?
  var title: String?
  var body: String?
  var dishId: Dish.ID

  init(title: String, body: String, dishId: Dish.ID) {
    self.title = title
    self.body = body
    self.dishId = dishId
  }
}

extension Review {
  var dish: Parent<Review, Dish> {
    return parent(\.dishId)
  }
}

extension Review: Migration { }

extension Review: Parameter { }

extension Review: SQLiteModel {
  static let entity: String = "reviews"
}