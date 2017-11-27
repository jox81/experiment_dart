import 'dart:html';
import 'package:angular2/core.dart';
@Directive(
  selector: '[clickOutside]'
)
class ClickOutsideDirective {

  ElementRef _elementRef;

  @Output()
  EventEmitter clickOutside = new EventEmitter<Object>();

  ClickOutsideDirective(this._elementRef) {
    window.onMouseDown.listen((MouseEvent event)=>onMouseDown(event.target));
  }

  void onMouseDown(EventTarget targetElement) {
    final bool clickedInside = this._elementRef.nativeElement.contains(targetElement) as bool;
    if (!clickedInside) {
      this.clickOutside.emit(null);
    }
  }
}

@Directive(
    selector: 'ul[counting]',
    host: const {
      '(click)': 'onClick(\$event.target)'
    })
class CountClicks {
  var numberOfClicks = 0;

  void onClick(Event el) {
    print("Element $el, number of clicks: ${numberOfClicks++}.");
  }
}