import 'dart:async';

/// Exemple using Observer Design Pattern
/// Based on http://www.dofactory.com/net/observer-design-pattern
///
/// Define a one-to-many dependency between objects so that when one object
/// changes state, all its dependents are notified and updated automatically.
Future main() async {
  // Configure Observer pattern
  ConcreteSubject s = new ConcreteSubject();

  s.Attach(new ConcreteObserver(s, "X"));
  s.Attach(new ConcreteObserver(s, "Y"));
  s.Attach(new ConcreteObserver(s, "Z"));

  // Change subject and notify observers
  s.subjectState = "ABC";
  s.Notify();
}

/// The 'Subject' abstract class
abstract class Subject {
  List<Observer> _observers = new List<Observer>();

  void Attach(Observer observer) {
    _observers.add(observer);
  }

  void Detach(Observer observer) {
    _observers.remove(observer);
  }

  void Notify() {
    for (Observer o in _observers) {
      o.Update();
    }
  }
}

/// The 'ConcreteSubject' class
class ConcreteSubject extends Subject {
  String _subjectState;
  String get subjectState => _subjectState;
  set subjectState(String value) {
    _subjectState = value;
  }
}

/// The 'Observer' abstract class
abstract class Observer {
  void Update();
}

/// The 'ConcreteObserver' class
class ConcreteObserver extends Observer {
  String _observerState;

  String _name;

  ConcreteSubject _subject;
  ConcreteSubject get subject => _subject;
  set subject(ConcreteSubject value) {
    _subject = value;
  }

  // Constructor
  ConcreteObserver(ConcreteSubject subject, String name) {
    this._subject = subject;
    this._name = name;
  }

  void Update() {
    _observerState = _subject.subjectState;
    print("Observer ${_name}'s new state is ${_observerState}");
  }
}
