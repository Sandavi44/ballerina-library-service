import ballerina/http;

type Book record {|
    readonly string id;
    string title;
    string author;
|};

table<Book> key(id) books = table [
    {id: "1", title: "Clean Code", author: "Robert C. Martin"}
];

service /library on new http:Listener(9090) {

    resource function get books() returns Book[] {
        return books.toArray();
    }

    resource function get books/[string id]() returns Book|http:NotFound {
        Book? book = books[id];
        if book is () {
            return http:NOT_FOUND;
        }
        return book;
    }

    resource function post books(Book newBook) returns Book|http:Conflict {
        if books.hasKey(newBook.id) {
            return http:CONFLICT;
        }
        books.add(newBook);
        return newBook;
    }
}