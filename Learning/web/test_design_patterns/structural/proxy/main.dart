import 'dart:async';

/// Exemple using Design Pattern extends Proxy
/// Based on http://www.dofactory.com/net/proxy-design-pattern
///
/// Provide a surrogate or placeholder for another object to control access to it.
///
/// This structural code demonstrates the Proxy pattern which provides a
/// representative object (proxy) that controls access to another similar object.
Future main() async {
  // Create proxy and request a service
  Proxy proxy = new Proxy();
  proxy.request();
}

/// The 'Subject' abstract class
abstract class Subject {
  void request();
}

/// The 'RealSubject' class
class RealSubject extends Subject {
  void request() {
    print("Called RealSubject.Request()");
  }
}

/// The 'Proxy' class
class Proxy extends Subject {
  RealSubject _realSubject;

  void request() {
    // Use 'lazy initialization'
    if (_realSubject == null) {
      _realSubject = new RealSubject();
    }

    _realSubject.request();
  }
}
