import SwiftKuery
import SwiftKueryPostgreSQL

class Grades : Table {
    let tableName = "Grades"
    let id = Column("id")
    let course = Column("course")
    let grade = Column("grade")
}

fileprivate func executeSelectQuery(_ connection: PostgreSQLConnection) {
    let query = Select(grades.grade, grades.course, grades.id, from: grades)
        connection.execute(query: query) { result in
            if let resultSet = result.asResultSet {
                for title in resultSet.titles {
                    print("Column: \(title)")
                }
                for row in resultSet.rows {
                    for value in row {
                        print("Row: \(value!)")
                    }
                }
            } else if let queryError = result.asError {
                print(queryError)
            }
    }
}

fileprivate func executeInsertQuery(_ connection: PostgreSQLConnection) {
    let query = Insert(into: grades, columns: [grades.id, grades.course, grades.grade], rows: [[86753, "Texas History", 89], [39876, "Texas History", 94]])
        connection.execute(query: query) { result in
            if result.success == true {
                print("Row added!")
            } else if let queryError = result.asError {
                print(queryError)
            }
    }
}

fileprivate func executeUpdateQuery(_ connection: PostgreSQLConnection) {
    let query = Update(grades, set: [(grades.course, "Geometry")]).where(grades.course == "Physics")
        connection.execute(query: query) { result in
            if result.success == true {
                print("Rows updated")
            } else if let queryError = result.asError {
                print(queryError)
            }
    }
}

fileprivate func executeDeleteQuery(_ connection: PostgreSQLConnection) {
    let query = Delete(from: grades, where: grades.course == "Texas History")
        connection.execute(query: query) { result in
            if result.success == true {
                print("Row deleted")
            } else if let queryError = result.asError {
                print(queryError)
            }
    }
}

let grades = Grades()

let connection = PostgreSQLConnection(host: "localhost", port: 5432, options: [.databaseName("postgres"), .userName("davidokunibm"), .password("")])
connection.connect { error in
    if let error = error {
        print(error)
    } else {
        print("PostgreSQL connection established")
        executeDeleteQuery(connection)
    }
}
