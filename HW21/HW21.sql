Шаг 1:
docker run -d -p 27017:27017 --name my-mongo mongo

Шаг 2:
2.1
docker exec -it my-mongo mongo
2.2
use library
db.createCollection("books")
2.3
db.books.insertMany([
  { title: "1984", author: "George Orwell", year: 1949, genre: "Dystopian" },
  { title: "To Kill a Mockingbird", author: "Harper Lee", year: 1960, genre: "Fiction" },
  { title: "The Great Gatsby", author: "F. Scott Fitzgerald", year: 1925, genre: "Fiction" },
  { title: "Brave New World", author: "Aldous Huxley", year: 1932, genre: "Dystopian" }
])

Шаг 3:
3.1
db.books.find({ genre: "Fiction" })
3.2
db.books.find({ title: "1984" })
3.3
db.books.updateOne(
  { title: "Brave New World" },
  { $set: { year: 1933 } }
)
3.4
db.books.deleteOne({ title: "The Great Gatsby" })

