import 'dart:async';

/// Exemple using Strategy Design Pattern
/// Based on http://www.dofactory.com/net/strategy-design-pattern
///
/// Define a family of algorithms, encapsulate each one, and make them interchangeable.
/// Strategy lets the algorithm vary independently from clients that use it.
Future main() async {
  Context context;

  // Three contexts following different strategies
  context = new Context(new ConcreteStrategyA());
  context.ContextInterface();

  context = new Context(new ConcreteStrategyB());
  context.ContextInterface();

  context = new Context(new ConcreteStrategyC());
  context.ContextInterface();
}

/// <summary>
/// The 'Context' class
/// </summary>
class Context {
  Strategy _strategy;

  // Constructor
  Context(Strategy strategy) {
    this._strategy = strategy;
  }

  void ContextInterface() {
    _strategy.AlgorithmInterface();
  }
}

/// <summary>
/// The 'Strategy' abstract class
/// </summary>
abstract class Strategy {
  void AlgorithmInterface();
}

/// <summary>
/// A 'ConcreteStrategy' class
/// </summary>
class ConcreteStrategyA extends Strategy {
  void AlgorithmInterface() {
    print("Called ConcreteStrategyA.AlgorithmInterface()");
  }
}

/// <summary>
/// A 'ConcreteStrategy' class
/// </summary>
class ConcreteStrategyB extends Strategy {
  void AlgorithmInterface() {
    print("Called ConcreteStrategyB.AlgorithmInterface()");
  }
}

/// <summary>
/// A 'ConcreteStrategy' class
/// </summary>
class ConcreteStrategyC extends Strategy {
  void AlgorithmInterface() {
    print("Called ConcreteStrategyC.AlgorithmInterface()");
  }
}
