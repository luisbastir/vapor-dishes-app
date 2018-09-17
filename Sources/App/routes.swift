import Vapor
import FluentSQLite

/// Register your application's routes here.
public func routes(_ router: Router) throws {

  let dishesController = DishesController()
  try router.register(collection: dishesController)
}
