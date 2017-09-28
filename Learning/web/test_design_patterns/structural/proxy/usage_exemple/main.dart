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
  print("4 + 2 = ${proxy.Add(4, 2)}");
  print("4 - 2 = ${proxy.Sub(4, 2)}");
  print("4 * 2 = ${proxy.Mul(4, 2)}");
  print("4 / 2 = ${proxy.Div(4, 2)}");
}

/// <summary>
/// The 'Subject interface
/// </summary>
abstract class IMath {
  num Add(num x, num y);
  num Sub(num x, num y);
  num Mul(num x, num y);
  num Div(num x, num y);
}

/// <summary>
/// The 'RealSubject' class
/// </summary>
class Math extends IMath {
  num Add(num x, num y) {
    return x + y;
  }

  num Sub(num x, num y) {
    return x - y;
  }

  num Mul(num x, num y) {
    return x * y;
  }

  num Div(num x, num y) {
    return x / y;
  }
}

/// <summary>
/// The 'Proxy Object' class
/// </summary>
class MathProxy extends IMath {
  Math _math = new Math();

  num Add(num x, num y) {
    return _math.Add(x, y);
  }

  num Sub(num x, num y) {
    return _math.Sub(x, y);
  }

  num Mul(num x, num y) {
    return _math.Mul(x, y);
  }

  num Div(num x, num y) {
    return _math.Div(x, y);
  }
}
