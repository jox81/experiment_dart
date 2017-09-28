import 'dart:async';

/// Exemple using Design Pattern extends Decorator
/// Based on http://www.dofactory.com/net/design-patterns
///
/// Attach additional responsibilities to an object dynamically.
/// Decorators provide a flexible alternative to subclassing for extending functionality.
///
/// This real-world code demonstrates the Decorator pattern in which 'borrowable'
/// functionality is added to existing library items (books and videos).
Future main() async {
  // Create book
  Book book = new Book("Worley", "Inside ASP.NET", 10);
  book.display();

  // Create video
  Video video = new Video("Spielberg", "Jaws", 23, 92);
  video.display();

  // Make video borrowable, then borrow and display
  print("\nMaking video borrowable:");

  Borrowable borrowvideo = new Borrowable(video);
  borrowvideo.borrowItem("Customer #1");
  borrowvideo.borrowItem("Customer #2");

  borrowvideo.display();
}

/// The 'Component' abstract class
abstract class LibraryItem {
  int _numCopies;
  int get numCopies => _numCopies;
  set numCopies(int value) {
    _numCopies = value;
  }

  void display();
}

/// The 'ConcreteComponent' class
class Book extends LibraryItem {
  String _author;
  String _title;

  // Constructor
  Book(String author, String title, int numCopies) {
    this._author = author;
    this._title = title;
    this.numCopies = numCopies;
  }

  void display() {
    print("\nBook ------ ");
    print(" Author: ${_author}");
    print(" Title: ${_title}");
    print(
      " # Copies: ${numCopies}",
    );
  }
}

/// The 'ConcreteComponent' class
class Video extends LibraryItem {
  String _director;
  String _title;
  int _playTime;

  // Constructor
  Video(String director, String title, int numCopies, int playTime) {
    this._director = director;
    this._title = title;
    this.numCopies = numCopies;
    this._playTime = playTime;
  }

  void display() {
    print("\nVideo ----- ");
    print(" Director: ${_director}");
    print(" Title: ${_title}");
    print(" # Copies: ${numCopies}");
    print(" Playtime: ${_playTime}\n");
  }
}

/// The 'Decorator' abstract class
abstract class Decorator extends LibraryItem {
  LibraryItem libraryItem;

  // Constructor
  Decorator(LibraryItem libraryItem) {
    this.libraryItem = libraryItem;
  }

  void display() {
    libraryItem.display();
  }
}

/// The 'ConcreteDecorator' class
class Borrowable extends Decorator {
  List<String> borrowers = new List<String>();

  // Constructor
  Borrowable(LibraryItem libraryItem) : super(libraryItem) {}

  void borrowItem(String name) {
    borrowers.add(name);
    libraryItem.numCopies--;
  }

  void returnItem(String name) {
    borrowers.remove(name);
    libraryItem.numCopies++;
  }

  void display() {
    super.display();

    for (String borrower in borrowers) {
      print(" borrower: " + borrower);
    }
  }
}
