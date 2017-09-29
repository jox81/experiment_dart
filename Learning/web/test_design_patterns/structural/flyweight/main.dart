import 'dart:async';
import 'dart:collection';

/// Exemple using Design Pattern extends Flyweight
/// Based on http://www.dofactory.com/net/flyweight-design-pattern
///
/// Use sharing to support large numbers of fine-grained objects efficiently.
///
/// This structural code demonstrates the Flyweight pattern in which a relatively
/// small number of objects is shared many times by different clients.
Future main() async {
  // Arbitrary extrinsic state
  int extrinsicstate = 22;

  FlyweightFactory factory = new FlyweightFactory();

  // Work with different flyweight instances
  Flyweight fx = factory.GetFlyweight("X");
  fx.Operation(--extrinsicstate);

  Flyweight fy = factory.GetFlyweight("Y");
  fy.Operation(--extrinsicstate);

  Flyweight fz = factory.GetFlyweight("Z");
  fz.Operation(--extrinsicstate);

  UnsharedConcreteFlyweight fu = new UnsharedConcreteFlyweight();

  fu.Operation(--extrinsicstate);
}

/// The 'FlyweightFactory' class
class FlyweightFactory {
  HashMap flyweights = new HashMap();

  // Constructor
  FlyweightFactory() {
    flyweights["X"] = new ConcreteFlyweight();
    flyweights["Y"] = new ConcreteFlyweight();
    flyweights["Z"] = new ConcreteFlyweight();
  }

  Flyweight GetFlyweight(String key) {
    return flyweights[key] as Flyweight;
  }
}

/// The 'Flyweight' abstract class
abstract class Flyweight {
  void Operation(int extrinsicstate);
}

/// The 'ConcreteFlyweight' class
class ConcreteFlyweight extends Flyweight {
  void Operation(int extrinsicstate) {
    print("ConcreteFlyweight: $extrinsicstate");
  }
}

/// The 'UnsharedConcreteFlyweight' class
class UnsharedConcreteFlyweight extends Flyweight {
  void Operation(int extrinsicstate) {
    print("UnsharedConcreteFlyweight: $extrinsicstate");
  }
}
