import 'dart:async';
import 'dart:collection';

/// Exemple using Design Pattern extends Flyweight
/// Based on http://www.dofactory.com/net/flyweight-design-pattern
///
/// Use sharing to support large numbers of fine-grained objects efficiently.
///
/// This real-world code demonstrates the Flyweight pattern in which a relatively
/// small number of Character objects is shared many times by a document that
/// has potentially many characters.
Future main() async {
  // Build a document with text
  String document = "AAZZBBZB";
  List<String> chars = document.split('');

  CharacterFactory factory = new CharacterFactory();

  // extrinsic state
  int pointSize = 10;

  // For each character use a flyweight object
  for (String c in chars) {
    pointSize++;
    Character character = factory.GetCharacter(c);
    character.Display(pointSize);
  }
}

/// The 'FlyweightFactory' class
class CharacterFactory {
  Map<String, Character> _characters = new Map();

  Character GetCharacter(String key) {
    // Uses "lazy initialization"
    Character character = null;
    if (_characters.containsKey(key)) {
      character = _characters[key];
    } else {
      switch (key) {
        case 'A':
          character = new CharacterA();
          break;
        case 'B':
          character = new CharacterB();
          break;
        //...
        case 'Z':
          character = new CharacterZ();
          break;
      }
      _characters[key] = character;
    }
    return character;
  }
}

/// The 'Flyweight' abstract class
abstract class Character {
  String symbol;
  int width;
  int height;
  int ascent;
  int descent;
  int pointSize;

  void Display(int pointSize);
}

/// A 'ConcreteFlyweight' class
class CharacterA extends Character {
// Constructor
  CharacterA() {
    this.symbol = 'A';
    this.height = 100;
    this.width = 120;
    this.ascent = 70;
    this.descent = 0;
  }

  void Display(int pointSize) {
    this.pointSize = pointSize;
    print("$symbol (pointsize $pointSize)");
  }
}

/// A 'ConcreteFlyweight' class
class CharacterB extends Character {
// Constructor
  CharacterB() {
    this.symbol = 'B';
    this.height = 100;
    this.width = 140;
    this.ascent = 72;
    this.descent = 0;
  }

  void Display(int pointSize) {
    this.pointSize = pointSize;
    print(symbol + " (pointsize $pointSize)");
  }
}

// ... C, D, E, etc.

/// A 'ConcreteFlyweight' class
class CharacterZ extends Character {
// Constructor
  CharacterZ() {
    this.symbol = 'Z';
    this.height = 100;
    this.width = 100;
    this.ascent = 68;
    this.descent = 0;
  }

  void Display(int pointSize) {
    this.pointSize = pointSize;
    print(this.symbol + " (pointsize ${this.pointSize})");
  }
}
