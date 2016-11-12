import 'dart:async';
import 'dart:html';
import 'package:angular2/core.dart';

@Component(
    selector: 'canvas_app',
    templateUrl: 'canvas_component.html',
    styleUrls: const ['canvas_component.css'])
class CanvasComponent implements AfterViewInit{

  @ViewChild("myCanvas")
  ElementRef myCanvas;

  CanvasElement canvas;

  @override
  ngAfterViewInit() {
    canvas = myCanvas.nativeElement;
  }
}