//
//  SwiftSqliteUse.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/12.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation
import SQLite

class dbUse {
    func useDB() {
        /// 连接数据库
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let db = try? Connection("\(path)/db.sqlite3")
        
        
        //从程序中读取的db文件可以设置为制度数据库
        let path2 = Bundle.main.path(forResource: "db", ofType: "sqlite3")!
        
        let db2 = try! Connection(path2, readonly: true)
        
        //内存数据库,不设置路径
        let db3 = try! Connection() // equivalent to `Connection(.inMemory)`
        let db4 = try! Connection(.temporary)//要创建一个临时的，磁盘支持的数据库，请传递一个空文件名
        
        //每个连接都配有自己的串行队列，用于语句执行，并可以跨线程安全访问。打开事务和保存点的线程将在事务打开时阻止其他线程执行语句。如果您为单个数据库维护多个连接，请考虑设置超时（以秒为单位）和/或忙碌处理程序,每个连接都是一个单独的线程吗?没有像fmdb的直接异步接口吗?
        db?.busyTimeout = 5
        db?.busyHandler({ tries in
            if tries >= 3 {
                return false
            }
            return true
        })
        
        //创建表
        let users = Table("users") //temporary:是否可创建临时表 ifNotExists:表存在读取缓存
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")
        //        let name = Expression<String?>("name") //可选类型的支持
        let email = Expression<String>("email")
        let age = Expression<String>("age")
        
        
        
        //临时属性,temp,是否可以创建临时表:用于在数据库中删除和增加列,可读可写的数据数据库
        try! db?.run(users.create(ifNotExists: true) { (table) in
            table.column(id, primaryKey: true)
            table.column(name)
            table.column(email,unique:true)
            table.column(age)
            
            //column Constraints 列限制
            //列属性: primaryKey:主键 unique:是否可重复 check:判断条件 defaultValue:默认值 collate:校对,进行定义这一行的比较方式 references:联合
            //collate:
            //            BINARY(默认),他通过使用C函数--memcmp()，一个字节一个字节的进行比较
            //            这种方式很好的适用于西方的语言,如English
            //            NOCASE,是在英语中通过26个ASCII字符进行比较的
            //            eg.'JERRY'和'Jerry'被认为是一样的
            //            REVERSE,更多的用于测试!
//            t.column(id, primaryKey: true)
//            // "id" INTEGER PRIMARY KEY NOT NULL
//            
//            t.column(id, primaryKey: .autoincrement)
//            // "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
//            t.column(email, unique: true)
//            // "email" TEXT UNIQUE NOT NULL
//            t.column(email, check: email.like("%@%"))
//            // "email" TEXT NOT NULL CHECK ("email" LIKE '%@%')
//            t.column(name, defaultValue: "Anonymous")
//            // "name" TEXT DEFAULT 'Anonymous'
//            t.column(email, collate: .nocase)
//            // "email" TEXT NOT NULL COLLATE "NOCASE"
//            
//            t.column(name, collate: .rtrim)
//            // "name" TEXT COLLATE "RTRIM"
//            t.column(user_id, references: users, id)
//            // "user_id" INTEGER REFERENCES "users" ("id")
        })
        
        //table Constraints:表限制
        //primaryKey:主键 unique:是否可重复 check:判断条件 foreignKey:外键
//        primaryKey adds a PRIMARY KEY constraint to the table. Unlike the column constraint, above, it supports all SQLite types, ascending and descending orders, and composite (multiple column) keys.
//        
//        t.primaryKey(email.asc, name)
//        // PRIMARY KEY("email" ASC, "name")
//        unique adds a UNIQUE constraint to the table. Unlike the column constraint, above, it supports composite (multiple column) constraints.
//        
//        t.unique(local, domain)
//        // UNIQUE("local", "domain")
//        check adds a CHECK constraint to the table in the form of a boolean expression (Expression<Bool>). Boolean expressions can be easily built using filter operators and functions. (See also the check parameter under Column Constraints.)
//        
//        t.check(balance >= 0)
//        // CHECK ("balance" >= 0.0)
//        foreignKey adds a FOREIGN KEY constraint to the table. Unlike the references constraint, above, it supports all SQLite types, both ON UPDATE and ON DELETE actions, and composite (multiple column) keys.
//        
//        t.foreignKey(user_id, references: users, id, delete: .setNull)
        // FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE SET NULL
        
        
        
        /// 插入操作,返回rowid
        let insert = users.insert(name <- "大会上", email <- "djahsdjkh@126.com")
        let rowid = (try! db?.run(insert))!
        let insert2 = users.insert(name <- "WTF",email <- "dasdasdghj@163.com")
        let rowid2 = (try! db?.run(insert2))!
        
        //更新
        let update = users.filter(id == rowid)
        try! db?.run(update.update(email <- email.replace("126", with: "qq")))
        
        for user in (try! db?.prepare(users.filter(name == "大会上")))! {
            print("Update:id: \(user[id]), name: \(user[name]), email: \(user[email])")
        }
        
        //删除
        try! db?.run(users.filter(id == rowid2).delete())
        for user in (try! db?.prepare(users))! {
            print("Delete:id: \(user[id]), name: \(user[name]), email: \(user[email])")
        }
        
        //setters
        //表里的属性和值关联,通过,运算符重写的:<-
//        try db.run(counter.update(count <- 0))
        // UPDATE "counters" SET "count" = 0 WHERE ("id" = 1)
        //其他重载的运算符
//        Operator	Types
//            <-	Value -> Value
//            +=	Number -> Number
//            -=	Number -> Number
//            *=	Number -> Number
//            /=	Number -> Number
//            %=	Int -> Int
//            <<=	Int -> Int
//            >>=	Int -> Int
//            &=	Int -> Int
//        `	
//        ^=	Int -> Int
//        +=	String -> String
//        Postfix Setters
//        
//        Operator	Types
//        ++	Int -> Int
//        --	Int -> Int
        
        //查询操作
        //查询操作是懒惰执行的
        for user in (try! db?.prepare(users))!{
            print("id: \(user[id]), email: \(user[email]), name: \(user[name])")
        }
        
        //获取第一行
        if let user = try! db?.pluck(users) { /* ... */ } // Row
        // SELECT * FROM "users" LIMIT 1
        
        let all = Array((try! db?.prepare(users))!)
        // SELECT * FROM "users"
        
        //查询语句的复合操作
        let query = users.select(email)           // SELECT "email" FROM "users"
//            .filter(name != nil)     // WHERE "name" IS NOT NULL //fiter为啥不行,重写了 != ,fiter中左右比较必须是同一类型
            .order(email.desc, name) // ORDER BY "email" DESC, "name"
            .limit(5, offset: 1)     // LIMIT 5 OFFSET 1
            .filter(name != "")
        
        //直接使用元组获取指定的列
        for user in (try! db?.prepare(users.select(id, email)))! {
            print("id: \(user[id]), email: \(user[email])")
            // id: 1, email: alice@mac.com
        }
        // SELECT "id", "email" FROM "users"
        
        //sentence封装直接对每列的处理
//        let sentence = name + " is " + cast(age) as Expression<String?> + " years old!"
//        for user in users.select(sentence) {
//            print(user[sentence])
//            // Optional("Alice is 30 years old!")
//        }
        // SELECT ((("name" || ' is ') || CAST ("age" AS TEXT)) || ' years old!') FROM "users"
        
        //当单表存在多种类型需要复杂的类型判断逻辑时,可以考虑合理的分表来解决
        //join,联合查询,联合查询确实有性能优化吗??
        //join的几种方式:
        /*
         1.cross join:SELECT ... FROM t1 CROSS JOIN t2 ...叫笛卡尔积，匹配前一个表与后一个表的每一行和每一列，这样得到的结果集为n*m行（n, m分别为每张表的行数），x+y列（x, y分别为每张表的列数）。可见，该结果集可能会成为一个巨大的表，对内存和后续处理都会造成巨大压力，所以，慎用（真没用过）
         2.inner join:类似Cross Join，但内建机制限制了返回的结果数量。返回的结果集不会超过x + y列，行数在0- n*m行之间。有3种方法用来指定Inner Join的判断条件：
         第一种是On表达式：SELECT ... FROM t1 JOIN t2 ON conditional_expression ...，例如：SELECT ... FROM employee JOIN resource ON employee.eid = resource.eid ...。
         但On这种方式有俩个问题：一是语句比较长，二是存在重复列，如俩个eid。因此，可以使用第二种方式Using表达式：SELECT ... FROM t1 JOIN t2 USING ( col1 ,... ) ...，这种Join返回的结果集中没有重复的字段，只是每个字段必须存在于各个表中。
         更简洁的方式是，使用第三种方式Natural Join：SQL自动检测各表中每一列是否匹配，这样，即使表结构发生变化，也不用修改SQL语句，可以自动适应变化。
         3.Outer Join:SQLite3只支持left outer join，其结果集由不大于x + y列，n - n*m行构成，至少包含左侧表的每一行，对于Join后不存在的字段值，则赋NULL。这样得到的表与我们之前设计那个全集结果一样，但数据结构更清晰，空间占用更少。
         */

//        users.join(posts, on: user_id == users[id])
        // SELECT * FROM "users" INNER JOIN "posts" ON ("user_id" = "users"."id")
//        let query = users.join(posts, on: user_id == id)
        // assertion failure: ambiguous column 'id'
        
        //表的临时名字
        let managers = users.alias("managers")
//        let query5 = users.join(managers, on: managers[id] == users[managerId])
        // SELECT * FROM "users"
        // INNER JOIN ("users") AS "managers" ON ("managers"."id" = "users"."manager_id")
        
        users.where(id == 1)
        // SELECT * FROM "users" WHERE ("id" = 1)
        
//        If query results can have ambiguous column names, row values should be accessed with namespaced column expressions. In the above case, SELECT * immediately namespaces all columns of the result set.
//        
//        let user = try db.pluck(query)
//        user[id]           // fatal error: ambiguous column 'id'
//        // (please disambiguate: ["users"."id", "managers"."id"])
//        
//        user[users[id]]    // returns "users"."id"
//        user[managers[id]] // returns "managers"."id"
        
        //where 代替fiter,筛选操作
        users.where(id == 1)
        
        //fiter重写的运算符
//            ==	Equatable -> Bool	=/IS*
//                !=	Equatable -> Bool	!=/IS NOT*
//                    >	Comparable -> Bool	>
//                    >=	Comparable -> Bool	>=
//                    <	Comparable -> Bool	<
//                    <=	Comparable -> Bool	<=
//                    ~=	(Interval, Comparable) -> Bool	BETWEEN
//                        &&	Bool -> Bool	AND
//        `		`
//        Swift	Types	SQLite
//        like	String -> Bool	LIKE
//        glob	String -> Bool	GLOB
//        match	String -> Bool	MATCH
//        contains	(Array<T>, T) -> Bool	IN
        
        //排序:order,asc,desc
        users.order(email, name)
        
        //限制:limit
        users.limit(5)
        
        //聚合操作:Aggregation,一些数量关系上得直接处理
//        let count = try db.scalar(users.count)
//        // SELECT count(*) FROM "users"
//        let count = try db.scalar(users.count)
//        // SELECT count(*) FROM "users"
//        Filtered queries will appropriately filter aggregate values.
//        
//        let count = try db.scalar(users.filter(name != nil).count)
//        // SELECT count(*) FROM "users" WHERE "name" IS NOT NULL
//        count as a computed property on a query (see examples above) returns the total number of rows matching the query.
//        
//        count as a computed property on a column expression returns the total number of rows where that column is not NULL.
//        
//        let count = try db.scalar(users.select(name.count)) // -> Int
//        // SELECT count("name") FROM "users"
//        max takes a comparable column expression and returns the largest value if any exists.
//        
//        let max = try db.scalar(users.select(id.max)) // -> Int64?
//        // SELECT max("id") FROM "users"
//        min takes a comparable column expression and returns the smallest value if any exists.
//        
//        let min = try db.scalar(users.select(id.min)) // -> Int64?
//        // SELECT min("id") FROM "users"
//        average takes a numeric column expression and returns the average row value (as a Double) if any exists.
//        
//        let average = try db.scalar(users.select(balance.average)) // -> Double?
//        // SELECT avg("balance") FROM "users"
//        sum takes a numeric column expression and returns the sum total of all rows if any exist.
//        
//        let sum = try db.scalar(users.select(balance.sum)) // -> Double?
//        // SELECT sum("balance") FROM "users"
//        total, like sum, takes a numeric column expression and returns the sum total of all rows, but in this case always returns a Double, and returns 0.0 for an empty query.
//        
//        let total = try db.scalar(users.select(balance.total)) // -> Double
        // SELECT total("balance") FROM "users"
        
        //update rows:更新rows
//        hen an unscoped query calls update, it will update every row in the table.
//        
//        try db.run(users.update(email <- "alice@me.com"))
//        // UPDATE "users" SET "email" = 'alice@me.com'
//        Be sure to scope UPDATE statements beforehand using the filter function.
//        
//        let alice = users.filter(id == 1)
//        try db.run(alice.update(email <- "alice@me.com"))
//        // UPDATE "users" SET "email" = 'alice@me.com' WHERE ("id" = 1)
//        The update function returns an Int representing the number of updated rows.
//        
//        do {
//            if try db.run(alice.update(email <- "alice@me.com")) > 0 {
//                print("updated alice")
//            } else {
//                print("alice not found")
//            }
//        } catch {
//            print("update failed: \(error)")
//        }
        
        //delete rows:删除rows
//        We can delete rows from a table by calling a query’s delete function.
//        
//        When an unscoped query calls delete, it will delete every row in the table.
//        
//        try db.run(users.delete())
//        // DELETE FROM "users"
//        Be sure to scope DELETE statements beforehand using the filter function.
//        
//        let alice = users.filter(id == 1)
//        try db.run(alice.delete())
//        // DELETE FROM "users" WHERE ("id" = 1)
//        The delete function returns an Int representing the number of deleted rows.
//        
//        do {
//            if try db.run(alice.delete()) > 0 {
//                print("deleted alice")
//            } else {
//                print("alice not found")
//            }
//        } catch {
//            print("delete failed: \(error)")
//        }
        
        //Transactions and Savepoints:事物和保存点 使用事务和savepoint函数，我们可以在事务中运行一系列语句。如果单个语句失败或块抛出错误，则更改将回滚
//        try db.transaction {
//            let rowid = try db.run(users.insert(email <- "betty@icloud.com"))
//            try db.run(users.insert(email <- "cathy@icloud.com", managerId <- rowid))
//        }
        
        //表重命名
//        try db.run(users.rename(Table("users_old"))
        // ALTER TABLE "users" RENAME TO "users_old"
        
        //添加列:支持的列操作属性:check,defaulvalue,collate,reference
//        try db.run(users.addColumn(suffix))
        // ALTER TABLE "users" ADD COLUMN "suffix" TEXT
        
        //索引操作------------------------------------------------------------重要
        //建立索引:
        try! db?.run(users.createIndex(email))
//        The createIndex function has a couple default parameters we can override.
//        
//        unique adds a UNIQUE constraint to the index. Default: false.
//        
//        try db.run(users.createIndex(email, unique: true))
//        // CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email")
//        ifNotExists adds an IF NOT EXISTS clause to the CREATE TABLE statement (which will bail out gracefully if the table already exists). Default: false.
//        
//        try db.run(users.createIndex(email, ifNotExists: true))
//        // CREATE INDEX IF NOT EXISTS "index_users_on_email" ON "users" ("email"
        //去除索引
//        We can build DROP INDEX statements by calling the dropIndex function on a SchemaType.
//        
        try! db?.run(users.dropIndex(email))
//        // DROP INDEX "index_users_on_email"
//        The dropIndex function has one additional parameter, ifExists, which (when true) adds an IF EXISTS clause to the statement.
//        
//        try db.run(users.dropIndex(email, ifExists: true))
        // DROP INDEX IF EXISTS "index_users_on_email"
        
        //删除表
        try! db?.run(users.drop())
        // DROP TABLE "users"
        try! db?.run(users.drop(ifExists: true))
        // DROP TABLE IF EXISTS "users"
        
        //版本管理
        //设置版本
//        extension Connection {
//            public var userVersion: Int32 {
//                get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
//                set { try! run("PRAGMA user_version = \(newValue)") }
//            }
//        }
        //使用版本
//        if db.userVersion == 0 {
//            // handle first migration
//            db.userVersion = 1
//        }
//        if db.userVersion == 1 {
//            // handle second migration
//            db.userVersion = 2
//        }
        
        //自定义数据类型入库,遵守Value,实现方法,不支持下标
//        extension Date: Value {
//            class var declaredDatatype: String {
//                return String.declaredDatatype
//            }
//            class func fromDatatypeValue(stringValue: String) -> Date {
//                return SQLDateFormatter.dateFromString(stringValue)!
//            }
//            var datatypeValue: String {
//                return SQLDateFormatter.stringFromDate(self)
//            }
//        }
//        
//        let SQLDateFormatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
//            formatter.locale = Locale(localeIdentifier: "en_US_POSIX")
//            formatter.timeZone = TimeZone(forSecondsFromGMT: 0)
//            return formatter
//        }()
        
        //二进制数据的处理
//        extension UIImage: Value {
//            public class var declaredDatatype: String {
//                return Blob.declaredDatatype
//            }
//            public class func fromDatatypeValue(blobValue: Blob) -> UIImage {
//                return UIImage(data: Data.fromDatatypeValue(blobValue))!
//            }
//            public var datatypeValue: Blob {
//                return UIImagePNGRepresentation(self)!.datatypeValue
//            }
//            
//        }
        //通过使用命名空间来代替下标方法
//        Namespace expressions. Use the namespace function, instead:
//        
//        let avatar = Expression<UIImage?>("avatar")
//        users[avatar]           // fails to compile
//        users.namespace(avatar) // "users"."avatar"
        
        //拓展下标方法
//        extension Query {
//            subscript(column: Expression<UIImage>) -> Expression<UIImage> {
//                return namespace(column)
//            }
//            subscript(column: Expression<UIImage?>) -> Expression<UIImage?> {
//                return namespace(column)
//            }
//        }
//        
//        extension Row {
//            subscript(column: Expression<UIImage>) -> UIImage {
//                return get(column)
//            }
//            subscript(column: Expression<UIImage?>) -> UIImage? {
//                return get(column)
//            }
//        }
        
        //自定义sql函数
//        Many of SQLite’s core functions have been surfaced in and type-audited for SQLite.swift.
//        
//        Note: SQLite.swift aliases the ?? operator to the ifnull function.
//        
//        name ?? email // ifnull("name", "email")
//        Aggregate SQLite Functions
//        
//        Most of SQLite’s aggregate functions have been surfaced in and type-audited for SQLite.swift.
//            
//            Custom SQL Functions
//        
//        We can create custom SQL functions by calling createFunction on a database connection.
//        
//        For example, to give queries access to MobileCoreServices.UTTypeConformsTo, we can write the following:
//        
//        import MobileCoreServices
//        
//        let typeConformsTo: (Expression<String>, Expression<String>) -> Expression<Bool> = (
//            try db.createFunction("typeConformsTo", deterministic: true) { UTI, conformsToUTI in
//                return UTTypeConformsTo(UTI, conformsToUTI)
//            }
//        )
//        Note: The optional deterministic parameter is an optimization that causes the function to be created with SQLITE_DETERMINISTIC.
//        Note typeConformsTo’s signature:
//        
//        (Expression<String>, Expression<String>) -> Expression<Bool>
//        Because of this, createFunction expects a block with the following signature:
//        
//        (String, String) -> Bool
//        Once assigned, the closure can be called wherever boolean expressions are accepted.
//        
//        let attachments = Table("attachments")
//        let UTI = Expression<String>("UTI")
//        
//        let images = attachments.filter(typeConformsTo(UTI, kUTTypeImage))
//        // SELECT * FROM "attachments" WHERE "typeConformsTo"("UTI", 'public.image')
//        Note: The return type of a function must be a core SQL type or conform to Value.
//        We can create loosely-typed functions by handling an array of raw arguments, instead.
//        
//        db.createFunction("typeConformsTo", deterministic: true) { args in
//            guard let UTI = args[0] as? String, conformsToUTI = args[1] as? String else { return nil }
//            return UTTypeConformsTo(UTI, conformsToUTI)
//        }
//        Creating a loosely-typed function cannot return a closure and instead must be wrapped manually or executed using raw SQL.
//        
//        let stmt = try db.prepare("SELECT * FROM attachments WHERE typeConformsTo(UTI, ?)")
//        for row in stmt.bind(kUTTypeImage) { /* ... */ }
        
        //自定义Collations
//        We can create custom collating sequences by calling createCollation on a database connection.
//        
//        try db.createCollation("NODIACRITIC") { lhs, rhs in
//            return lhs.compare(rhs, options: .diacriticInsensitiveSearch)
//        }
//        We can reference a custom collation using the Custom member of the Collation enumeration.
//        
//        restaurants.order(collate(.custom("NODIACRITIC"), name))
        // SELECT * FROM "restaurants" ORDER BY "name" COLLATE "NODIACRITIC"
        
        //使用sqlite的fst4模块实现全文搜索,和like性能相比极大的提升
//        We can create a virtual table using the FTS4 module by calling create on a VirtualTable.
//        
//        let emails = VirtualTable("emails")
//        let subject = Expression<String>("subject")
//        let body = Expression<String>("body")
//        
//        try db.run(emails.create(.FTS4(subject, body)))
//        // CREATE VIRTUAL TABLE "emails" USING fts4("subject", "body")
//        We can specify a tokenizer using the tokenize parameter.
//        
//        try db.run(emails.create(.FTS4([subject, body], tokenize: .Porter)))
//        // CREATE VIRTUAL TABLE "emails" USING fts4("subject", "body", tokenize=porter)
//        We can set the full range of parameters by creating a FTS4Config object.
//        
//        let emails = VirtualTable("emails")
//        let subject = Expression<String>("subject")
//        let body = Expression<String>("body")
//        let config = FTS4Config()
//            .column(subject)
//            .column(body, [.unindexed])
//            .languageId("lid")
//            .order(.desc)
//        
//        try db.run(emails.create(.FTS4(config))
//            // CREATE VIRTUAL TABLE "emails" USING fts4("subject", "body", notindexed="body", languageid="lid", order="desc")
//            Once we insert a few rows, we can search using the match function, which takes a table or column as its first argument and a query string as its second.
//            
//            try db.run(emails.insert(
//            subject <- "Just Checking In",
//            body <- "Hey, I was just wondering...did you get my last email?"
//            ))
//        
//        let wonderfulEmails: QueryType = emails.match("wonder*")
//        // SELECT * FROM "emails" WHERE "emails" MATCH 'wonder*'
//        
//        let replies = emails.filter(subject.match("Re:*"))
//        // SELECT * FROM "emails" WHERE "subject" MATCH 'Re:*'
        
        //FST5
//        When linking against a version of SQLite with FTS5 enabled we can create the virtual table in a similar fashion.
//        
//        let emails = VirtualTable("emails")
//        let subject = Expression<String>("subject")
//        let body = Expression<String>("body")
//        let config = FTS5Config()
//            .column(subject)
//            .column(body, [.unindexed])
//        
//        try db.run(emails.create(.FTS5(config))
//        // CREATE VIRTUAL TABLE "emails" USING fts5("subject", "body" UNINDEXED)
//        
//        // Note that FTS5 uses a different syntax to select columns, so we need to rewrite
//        // the last FTS4 query above as:
//        let replies = emails.filter(emails.match("subject:\"Re:\"*))
//        // SELECT * FROM "emails" WHERE "emails" MATCH 'subject:"Re:"*'
//        // https://www.sqlite.org/fts5.html#_changes_to_select_statements_
        
        
        //原始sql的执行
//        Executing Arbitrary SQL
//        
//        Though we recommend you stick with SQLite.swift’s type-safe system whenever possible, it is possible to simply and safely prepare and execute raw SQL statements via a Database connection using the following functions.
//        
//        execute runs an arbitrary number of SQL statements as a convenience.
//        
//        try db.execute(
//        "BEGIN TRANSACTION;" +
//        "CREATE TABLE users (" +
//        "id INTEGER PRIMARY KEY NOT NULL," +
//        "email TEXT UNIQUE NOT NULL," +
//        "name TEXT" +
//        ");" +
//        "CREATE TABLE posts (" +
//        "id INTEGER PRIMARY KEY NOT NULL," +
//        "title TEXT NOT NULL," +
//        "body TEXT NOT NULL," +
//        "published_at DATETIME" +
//        ");" +
//        "PRAGMA user_version = 1;" +
//        "COMMIT TRANSACTION;"
//        )
//        prepare prepares a single Statement object from a SQL string, optionally binds values to it (using the statement’s bind function), and returns the statement for deferred execution.
//        
//        let stmt = try db.prepare("INSERT INTO users (email) VALUES (?)")
//        Once prepared, statements may be executed using run, binding any unbound parameters.
//        
//        try stmt.run("alice@mac.com")
//        db.changes // -> {Some 1}
//        Statements with results may be iterated over, using the columnNames if useful.
//        
//        let stmt = try db.prepare("SELECT id, email FROM users")
//        for row in stmt {
//            for (index, name) in stmt.columnNames.enumerate() {
//                print ("\(name)=\(row[index]!)")
//                // id: Optional(1), email: Optional("alice@mac.com")
//            }
//        }
//        run prepares a single Statement object from a SQL string, optionally binds values to it (using the statement’s bind function), executes, and returns the statement.
//        
//        try db.run("INSERT INTO users (email) VALUES (?)", "alice@mac.com")
//        scalar prepares a single Statement object from a SQL string, optionally binds values to it (using the statement’s bind function), executes, and returns the first value of the first row.
//        
//        let count = try db.scalar("SELECT count(*) FROM users") as! Int64
//        Statements also have a scalar function, which can optionally re-bind values at execution.
//        
//        let stmt = try db.prepare("SELECT count (*) FROM users")
//        let count = try stmt.scalar() as! Int64

        
        //sql的打印
        #if DEBUG
//            db?.trace(print)
        #endif
        
    }
    
    
}

//extension Date: Value {
//    class var declaredDatatype: String {
//        return String.declaredDatatype
//    }
//    class func fromDatatypeValue(stringValue: String) -> Date {
//        return SQLDateFormatter.dateFromString(stringValue)!
//    }
//    var datatypeValue: String {
//        return SQLDateFormatter.stringFromDate(self)
//    }
//}

