import Vapor
import FluentSQLite

class AddingNewColumn :SQLiteMigration {
  static func prepare(on conn: SQLiteConnection) -> Future<Void> {
    return SQLiteDatabase.update(Dish.self, on: conn) { builder in
      builder.field(for: \.description)
    }
  }

  static func revert(on conn: SQLiteConnection) -> Future<Void> {
    return SQLiteDatabase.update(Dish.self, on: conn) { builder in
      builder.deleteField(for: \.description)
    }
  }
}