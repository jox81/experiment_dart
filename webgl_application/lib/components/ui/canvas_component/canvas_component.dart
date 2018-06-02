import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';

@Component(
    selector: 'canvas_app',
    templateUrl: 'canvas_component.html',
    styleUrls: const ['canvas_component.css'])
class CanvasComponent implements AfterViewInit{

  @ViewChild("appCanvasNG")
  HtmlElement appCanvas;

  CanvasElement canvas;

  @override
  void ngAfterViewInit() {
    canvas = appCanvas as CanvasElement;
  }
}

