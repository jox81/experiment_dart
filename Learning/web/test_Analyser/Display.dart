library test;
part 'Test.dart';

class Display extends Test {
  Display() {
    _name = "jerome";
    sayHello("$_message $_name");
  }

  String combine(String message1, String message2, int value){
    return '$message1 et $message2 : ${value.toString()}';
  }
}