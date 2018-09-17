import Vapor
import FluentSQLite

class DishesController: RouteCollection {
  
  func boot(router: Router) throws {
    let dishesRoutes = router.grouped("api/dishes")

    dishesRoutes.get("/", use: index)
    dishesRoutes.get(Dish.parameter, use: findById)
    dishesRoutes.post(Dish.self, at: "/", use: create)
    dishesRoutes.get("courses", String.parameter, use: findByCourse)
    //dishesRoutes.delete(Dish.self, use: remove)
  }

  func index(req: Request) -> Future<[Dish]> {
    return Dish.query(on: req).all()
  }

  func findById(req: Request) throws -> Future<Dish> {
    return try req.parameters.next(Dish.self)
  }

  func findByCourse(req: Request) throws -> Future<[Dish]> {
    let course = try req.parameters.next(String.self)
    return Dish.query(on: req).filter(\.course == course).all()
  }

  func create(req: Request, dish: Dish) throws -> Future<Dish> {
    return dish.save(on: req)
  }

  /*func remove(req: Request) throws -> Future<Dish> {
    try req.parameters.next(Dish.self).delete(on: req)
  }*/
}