import 'dart:async';

/// Exemple using Design Pattern extends Proxy
/// Based on http://www.dofactory.com/net/proxy-design-pattern
///
/// Provide a surrogate or placeholder for another object to control access to it.
///
/// This real-world code demonstrates the Proxy pattern for a Math object
/// represented by a MathProxy object.
Future main() async {
  // Create math proxy
  MathProxy proxy = new MathProxy();

  // Do the math
  print("4 + 2 = ${proxy.add(4, 2)}");
  print("4 - 2 = ${proxy.sub(4, 2)}");
  print("4 * 2 = ${proxy.mul(4, 2)}");
  print("4 / 2 = ${proxy.div(4, 2)}");
}

/// <summary>
/// The 'Subject interface
/// </summary>
abstract class IMath {
  num add(num x, num y);
  num sub(num x, num y);
  num mul(num x, num y);
  num div(num x, num y);
}

/// <summary>
/// The 'RealSubject' class
/// </summary>
class Math extends IMath {
  num add(num x, num y) {
    return x + y;
  }

  num sub(num x, num y) {
    return x - y;
  }

  num mul(num x, num y) {
    return x * y;
  }

  num div(num x, num y) {
    return x / y;
  }
}

/// <summary>
/// The 'Proxy Object' class
/// </summary>
class MathProxy extends IMath {
  Math _math = new Math();

  num add(num x, num y) {
    return _math.add(x, y);
  }

  num sub(num x, num y) {
    return _math.sub(x, y);
  }

  num mul(num x, num y) {
    return _math.mul(x, y);
  }

  num div(num x, num y) {
    return _math.div(x, y);
  }
}
