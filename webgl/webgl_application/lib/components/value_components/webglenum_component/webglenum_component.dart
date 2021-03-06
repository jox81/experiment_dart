import 'dart:async';

import 'package:angular/angular.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart';

import 'package:angular_forms/angular_forms.dart' as forms;

@Component(
    selector: 'webglEnum',
    templateUrl: 'webglenum_component.html',
    styleUrls: const ['webglenum_component.css'],
    directives: const <dynamic>[coreDirectives,
    forms.formDirectives]
)
class WebGLEnumComponent{

  @Input()
  List<WebGLEnum> webglEnums;

  @Input()
  WebGLEnum element;

  final _elementSelected = new StreamController<Object>.broadcast();

  @Output()
  Stream get elementSelected => _elementSelected.stream;

  void selectionChange(dynamic event){
    var selection = webglEnums[event.target.selectedIndex as int];
    _elementSelected.add(selection);
  }
}