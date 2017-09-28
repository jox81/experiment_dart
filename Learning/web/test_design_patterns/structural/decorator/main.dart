import 'dart:async';

/// Exemple using Design Pattern extends Decorator
/// Based on http://www.dofactory.com/net/design-patterns
///
/// Attach additional responsibilities to an object dynamically.
/// Decorators provide a flexible alternative to subclassing for extending functionality.
///
/// This structural code demonstrates the Decorator pattern which dynamically
/// adds extra functionality to an existing object.
Future main() async {
  // Create ConcreteComponent and two Decorators
  ConcreteComponent c = new ConcreteComponent();
  ConcreteDecoratorA decA = new ConcreteDecoratorA();
  ConcreteDecoratorB decB = new ConcreteDecoratorB();

  // Link decorators
  decA.setComponent(c);
  decB.setComponent(decA);

  decB.operation();
}

/// The 'Component' abstract class
abstract class Component {
  void operation();
}

/// The 'ConcreteComponent' class
class ConcreteComponent extends Component {
  @override
  void operation() {
    print("ConcreteComponent.Operation()");
  }
}

/// The 'Decorator' abstract class
abstract class Decorator extends Component {
  Component component;

  void setComponent(Component component) {
    this.component = component;
  }

  void operation() {
    if (component != null) {
      component.operation();
    }
  }
}

/// The 'ConcreteDecoratorA' class
class ConcreteDecoratorA extends Decorator {
  @override
  void operation() {
    super.operation();
    print("ConcreteDecoratorA.Operation()");
  }
}

/// The 'ConcreteDecoratorB' class
class ConcreteDecoratorB extends Decorator {
  @override
  void operation() {
    super.operation();
    addedBehavior();
    print("ConcreteDecoratorB.Operation()");
  }

  void addedBehavior() {
    print("ConcreteDecoratorB.addedBehavior()");
  }
}
