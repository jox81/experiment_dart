import 'dart:async';

import 'package:angular/angular.dart';
import 'package:webgl_application/components/ui/toolbar_button/toolbar_button_component.dart';
import 'package:webgl_application/src/ui_models/toolbar.dart';

@Component(
    selector: 'toolBar',
    pipes: const [commonPipes],
    templateUrl: 'toolbar_component.html',
    styleUrls: const ['toolbar_component.css'],
    directives: const <dynamic>[coreDirectives, ToolBarButtonComponent])
class ToolBarComponent implements OnInit, AfterViewInit, AfterContentChecked, AfterContentInit, AfterViewChecked, OnChanges, OnDestroy, DoCheck{

  @Input()
  ToolBar toolBar;

  void onToolBarButtonClicked(String key, UpdateToolBarItem updateToolBarItem, dynamic event){
    bool checked = event.target.checked as bool;
    print('onToolBarButtonClicked > $key: $checked');
    updateToolBarItem(checked);
  }

  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
//    print('ToolBarComponent.ngOnChanges');
  }
  @override
  void ngOnInit() {
//    print('ToolBarComponent.ngOnInit');
  }
  @override
  void ngDoCheck() {
//    print('ToolBarComponent.ngDoCheck');
  }
  @override
  void ngAfterContentInit() {
//    print('ToolBarComponent.ngAfterContentInit');
  }
  @override
  void ngAfterContentChecked() {
//    print('ToolBarComponent.ngAfterContentChecked');
  }
  @override
  void ngAfterViewInit() {
//    print('ToolBarComponent.ngAfterViewInit');
  }
  @override
  void ngAfterViewChecked() {
//    print('ToolBarComponent.ngAfterViewChecked');
  }
  @override
  void ngOnDestroy() {
//    print('ToolBarComponent.ngOnDestroy');
  }
}
