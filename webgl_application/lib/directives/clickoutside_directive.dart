import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
@Directive(
  selector: '[clickOutside]'
)
class ClickOutsideDirective {

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

@Directive(
    selector: 'ul[counting]',
// Todo (jpu) : replace depracated
//    host: const {
//      '(click)': 'onClick(\$event.target)'
//    }
    )
class CountClicks {
  var numberOfClicks = 0;

  void onClick(Event el) {
    print("Element $el, number of clicks: ${numberOfClicks++}.");
  }
}