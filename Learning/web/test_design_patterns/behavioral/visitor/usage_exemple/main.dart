import 'dart:async';

/// Exemple using Visitor Design Pattern
/// Based on http://www.dofactory.com/net/visitor-design-pattern
///
/// Represent an operation to be performed on the elements of an object structure.
/// Visitor lets you define a new operation without changing the classes of the elements on which it operates.
///
/// This real-world code demonstrates the Visitor pattern in which two objects
/// traverse a list of Employees and performs the same operation on each Employee.
/// The two visitor objects define different operations -- one adjusts vacation days and the other income.
Future main() async {
  // Setup employee collection
  Employees e = new Employees();
  e.attach(new Clerk());
  e.attach(new Director());
  e.attach(new President());

  // Employees are 'visited'
  e.accept(new IncomeVisitor());
  e.accept(new VacationVisitor());
}

/// The 'Visitor' interface
abstract class IVisitor {
  void visit(Element element);
}

/// A 'ConcreteVisitor' class
class IncomeVisitor extends IVisitor {
  void visit(Element element) {
    Employee employee = element as Employee;

    // Provide 10% pay raise
    employee.income *= 1.10;
    print(
        "${employee.runtimeType} ${employee.name}'s new income: ${employee.income}");
  }
}

/// A 'ConcreteVisitor' class
class VacationVisitor extends IVisitor {
  void visit(Element element) {
    Employee employee = element as Employee;

    // Provide 3 extra vacation days
    employee.vacationDays += 3;
    print(
        "${employee.runtimeType} ${employee.name}'s new vacation days: ${employee.vacationDays}");
  }
}

/// The 'Element' abstract class
abstract class Element {
  void accept(IVisitor visitor);
}

/// The 'ConcreteElement' class
class Employee extends Element {
  String _name;
  double _income;
  int _vacationDays;

// Constructor
  Employee(String name, double income, int vacationDays) {
    this._name = name;
    this._income = income;
    this._vacationDays = vacationDays;
  }
  String get name => _name;

  set name(String value) {
    _name = value;
  }

  double get income => _income;

  set income(double value) {
    _income = value;
  }

  int get vacationDays => _vacationDays;

  set vacationDays(int value) {
    _vacationDays = value;
  }

  void accept(IVisitor visitor) {
    visitor.visit(this);
  }
}

/// The 'ObjectStructure' class
class Employees {
  List<Employee> _employees = new List<Employee>();

  void attach(Employee employee) {
    _employees.add(employee);
  }

  void Detach(Employee employee) {
    _employees.remove(employee);
  }

  void accept(IVisitor visitor) {
    for (Employee e in _employees) {
      e.accept(visitor);
    }
    print('');
  }
}

// Three employee types

class Clerk extends Employee {
// Constructor
  Clerk() : super("Hank", 25000.0, 14) {}
}

class Director extends Employee {
// Constructor
  Director() : super("Elly", 35000.0, 16) {}
}

class President extends Employee {
// Constructor
  President() : super("Dick", 45000.0, 21) {}
}
