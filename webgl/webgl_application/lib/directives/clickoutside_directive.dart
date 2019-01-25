import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
@Directive(
  selector: '[clickOutside]'
)
class ClickOutsideDirective {

  // Todo (jpu) : how to replace this deprecated element
  ElementRef _elementRef;

  final _clickOutside = new StreamController<Object>.broadcast();

  @Output()
  Stream get clickOutside => _clickOutside.stream;

  ClickOutsideDirective(this._elementRef) {
    window.onMouseDown.listen((MouseEvent event)=>onMouseDown(event.target));
  }

  void onMouseDown(EventTarget targetElement) {
    final bool clickedInside = this._elementRef.nativeElement.contains(targetElement) as bool;
    if (!clickedInside) {
      _clickOutside.add(null);
    }
  }
}