import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:webgl_application/src/application.dart';

@Component(
    selector: 'canvas_app',
    templateUrl: 'canvas_component.html',
    styleUrls: const ['canvas_component.css'])
class CanvasComponent implements OnInit, AfterViewInit, AfterContentChecked, AfterContentInit, AfterViewChecked, OnChanges, OnDestroy{

  @ViewChild("appCanvasNG")
  HtmlElement appCanvas;

  CanvasElement canvas;

  CanvasComponent(){
    print('CanvasComponent.CanvasComponent $appCanvas');
  }

  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    print('CanvasComponent.ngOnChanges $appCanvas');
  }
  @override
  void ngOnInit() {
    print('CanvasComponent.ngOnInit $appCanvas');
    canvas = appCanvas as CanvasElement;
    Application.build(canvas);
  }
  @override
  void ngAfterContentInit() {
//    print('CanvasComponent.ngAfterContentInit $appCanvas');
  }
  @override
  void ngAfterContentChecked() {
//    print('CanvasComponent.ngAfterContentChecked $appCanvas');
  }
  @override
  void ngAfterViewInit() {
//    print('CanvasComponent.ngAfterViewInit $appCanvas');
  }
  @override
  void ngAfterViewChecked() {
//    print('CanvasComponent.ngAfterViewChecked $appCanvas');
  }
  @override
  void ngOnDestroy() {
//    print('CanvasComponent.ngOnDestroy $appCanvas');
  }
}

