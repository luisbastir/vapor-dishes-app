import Vapor
import FluentSQLite
import Leaf

/// Register your application's routes here.
public func routes(_ router: Router) throws {

  router.get("/") { request in
    return try Dish.query(on: request).all()
      .flatMap(to: View.self) { dishes in
        let dishesData = dishes.isEmpty ? nil : dishes
        let context = IndexContext(dishes: dishesData)
        return try request.view().render("index", context)
      }
  }

  router.get("/add-new-dish") { request in
    return try request.view().render("add-new-dish")
  }

  router.post(DeleteRequest.self, at: "/delete-dish") { request, deleteRequest -> Future<Response> in
    return Dish.query(on: request).filter(\.id == deleteRequest.dishId)
      .first().unwrap(or: Abort(.badRequest)).delete(on: request)
      .transform(to: request.redirect(to: "/"))
  }

  router.post(Dish.self, at: "/add-new-dish") { request, dish -> Future<Response> in
    return dish.save(on: request).transform(to: request.redirect(to: "/"))
  }

  router.get("/dishes", Dish.parameter) { request -> Future<View> in
    return try request.parameters.next(Dish.self)
      .flatMap(to: View.self) { dish in
        try dish.reviews.query(on: request).all().flatMap { reviews in
          let context = DishDetailContext(dish: dish, reviews: reviews)
          return try request.view().render("dish-details", context)
        }
      }
  }

  router.post(Dish.self, at: "/update-dish") { request, dish -> Future<Response> in
    return dish.update(on: request).transform(to: request.redirect(to: "/"))
  }

  router.post(Review.self, at: "/add-review") { request, review -> Future<Response> in
    return review.save(on: request).transform(to: request.redirect(to: "/dishes/\(review.dishId)"))
  }

  router.get("/reviews", Review.parameter, "dish") { request -> Future<Dish> in
    return try request.parameters.next(Review.self)
      .flatMap(to: Dish.self) { review in 
        return view.dish.get(on: request)
      }
  }

  let dishesController = DishesController()
  try router.register(collection: dishesController)
}

struct IndexContext: Encodable {
  var dishes: [Dish]?
}

struct DeleteRequest: Content {
  var dishId: Int?
}

struct DishDetailContext: Encodable {
  var dish: Dish?
  var reviews: [Review]
}