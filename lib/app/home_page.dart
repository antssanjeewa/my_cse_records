import 'package:firebase_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/book.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final String appTitle = "Book DB";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController bookNameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();

  bool isEditing = false;
  bool textFieldVisibility = false;

  String firestoreCollectionName = 'books';
  late Book currentBook;

  getAllBooks() {
    return FirebaseFirestore.instance.collection('books').snapshots();
  }

  addBook() async {
    Book book = Book(bookName: bookNameController.text, autorName: authorNameController.text);

    try {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await FirebaseFirestore.instance.collection(firestoreCollectionName).doc().set(book.toJson());
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  updateBook(Book book, String bookName, String authorName) {
    try {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.update(book.documentReference, {'bookName': bookName, 'autorName': authorName});
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  updateIfEditing() {
    if (isEditing) {
      updateBook(currentBook, bookNameController.text, authorNameController.text);
      setState(() {
        isEditing = false;
      });
    }
  }

  deleteBook(Book book) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      // await transaction.delete(book.documentReference);
    });
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getAllBooks(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          // return Text("OK");
          return buildList(context, (snapshot.data! as QuerySnapshot).docs);
        }
        return Text("End");
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => listBuildItem(context, data)).toList(),
    );
  }

  Widget listBuildItem(BuildContext context, DocumentSnapshot data) {
    final book = Book.fromSnapshot(data);
    return Padding(
      key: ValueKey(book.bookName),
      padding: EdgeInsets.symmetric(vertical: 19, horizontal: 1),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(4),
        ),
        child: SingleChildScrollView(
          child: ListTile(
            title: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.book,
                      color: Colors.yellow,
                    ),
                    Text(book.bookName.toString())
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: Colors.purple,
                    ),
                    Text(book.autorName.toString())
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                deleteBook(book);
              },
              icon: Icon(Icons.delete),
            ),
            onTap: () {
              setUpdateUI(book);
            },
          ),
        ),
      ),
    );
  }

  setUpdateUI(Book book) {
    bookNameController.text = book.bookName.toString();
    authorNameController.text = book.autorName.toString();

    setState(() {
      textFieldVisibility = true;
      isEditing = true;
      currentBook = book;
    });
  }

  button() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        child: Text(isEditing ? 'UPDATE' : 'ADD'),
        onPressed: () {
          if (isEditing) {
            updateIfEditing();
          } else {
            addBook();
          }

          setState(() {
            textFieldVisibility = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.appTitle),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                textFieldVisibility = !textFieldVisibility;
              });
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            textFieldVisibility
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: bookNameController,
                        decoration: InputDecoration(labelText: "Book Name", hintText: "Enter Book Name"),
                      ),
                      TextFormField(
                        controller: authorNameController,
                        decoration: InputDecoration(labelText: "Author Name", hintText: "Enter Author Name"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      button(),
                    ],
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            Text(
              "Books",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: buildBody(context),
            )
          ],
        ),
      ),
    );
  }
}
