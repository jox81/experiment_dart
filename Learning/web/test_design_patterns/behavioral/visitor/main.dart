import 'dart:async';

/// Exemple using Visitor Design Pattern
/// Based on http://www.dofactory.com/net/visitor-design-pattern
///
/// Represent an operation to be performed on the elements of an object structure.
/// Visitor lets you define a new operation without changing the classes of the elements on which it operates.
///
/// This structural code demonstrates the Visitor pattern in which an object
/// traverses an object structure and performs the same operation on each node in this structure.
/// Different visitor objects define different operations.
Future main() async {
  // Setup structure
  ObjectStructure o = new ObjectStructure();
  o.attach(new ConcreteElementA());
  o.attach(new ConcreteElementB());

  // Create visitor objects
  ConcreteVisitor1 v1 = new ConcreteVisitor1();
  ConcreteVisitor2 v2 = new ConcreteVisitor2();

  // Structure accepting visitors
  o.accept(v1);
  o.accept(v2);
}

/// The 'Visitor' abstract class
abstract class Visitor {
  void visitConcreteElementA(ConcreteElementA concreteElementA);
  void visitConcreteElementB(ConcreteElementB concreteElementB);
}

/// A 'ConcreteVisitor' class
class ConcreteVisitor1 extends Visitor {
  void visitConcreteElementA(ConcreteElementA concreteElementA) {
    print("${concreteElementA.runtimeType} visited by ${this.runtimeType}");
  }

  void visitConcreteElementB(ConcreteElementB concreteElementB) {
    print("${concreteElementB.runtimeType} visited by ${this.runtimeType}");
  }
}

/// A 'ConcreteVisitor' class
class ConcreteVisitor2 extends Visitor {
  void visitConcreteElementA(ConcreteElementA concreteElementA) {
    print("${concreteElementA.runtimeType} visited by ${this.runtimeType}");
  }

  void visitConcreteElementB(ConcreteElementB concreteElementB) {
    print("${concreteElementB.runtimeType} visited by ${this.runtimeType}");
  }
}

/// The 'Element' abstract class
abstract class Element {
  void accept(Visitor visitor);
}

/// A 'ConcreteElement' class
class ConcreteElementA extends Element {
  void accept(Visitor visitor) {
    visitor.visitConcreteElementA(this);
  }

  void operationA() {}
}

/// A 'ConcreteElement' class
class ConcreteElementB extends Element {
  void accept(Visitor visitor) {
    visitor.visitConcreteElementB(this);
  }

  void operationB() {}
}

/// The 'ObjectStructure' class
class ObjectStructure {
  List<Element> _elements = new List<Element>();

  void attach(Element element) {
    _elements.add(element);
  }

  void detach(Element element) {
    _elements.remove(element);
  }

  void accept(Visitor visitor) {
    for (Element element in _elements) {
      element.accept(visitor);
    }
  }
}