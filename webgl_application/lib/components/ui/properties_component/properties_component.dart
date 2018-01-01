import 'dart:html';
import 'dart:mirrors';
import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl_application/components/ui/properties_component/dynamic_load_html_component.dart';
import 'package:webgl_application/components/value_components/bool_component/bool_component.dart';
import 'package:webgl_application/components/value_components/function_component/dynamic_load_component.dart';
import 'package:webgl_application/components/value_components/function_component/function_component.dart';
import 'package:webgl_application/components/value_components/list_component/list_component.dart';
import 'package:webgl_application/components/value_components/map_component/map_component.dart';
import 'package:webgl_application/components/value_components/matrix3_component/matrix3_component.dart';
import 'package:webgl_application/components/value_components/matrix4_component/matrix4_component.dart';
import 'package:webgl_application/components/value_components/vector2_component/vector2_component.dart';
import 'package:webgl_application/components/value_components/vector3_component/vector3_component.dart';
import 'package:webgl_application/components/value_components/vector4_component/vector4_component.dart';
import 'package:webgl_application/components/value_components/webglenum_component/webglenum_component.dart';
import 'package:webgl/src/animation/animation_property.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/geometry/mesh_primitive.dart';
import 'package:webgl/src/material/material.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart';
import 'package:webgl/src/webgl_objects/webgl_active_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl_application/src/application.dart';

@Component(
    selector: 'properties',
    templateUrl: 'properties_component.html',
    styleUrls: const [
      'properties_component.css'
    ],
    directives: const <dynamic>[
      DynamicLoaderComponent,
      Vector2Component,
      Vector3Component,
      Vector4Component,
      Matrix3Component,
      Matrix4Component,
      ListComponent,
      MapComponent,
      BoolComponent,
      WebGLEnumComponent,
      FunctionComponent,
      DynamicLoaderHtmlComponent
    ])
class PropertiesComponent {
  Application get application => Application.instance;

  IEditElement _iEditElement;
  @Input()
  set iEditElement(IEditElement value) => _iEditElement = value;
  IEditElement get iEditElement => _iEditElement;

  @Output()
  EventEmitter innerSelectionChange = new EventEmitter<IEditElement>();

  //Null
  bool isNull(EditableProperty animationProperty) {
    bool result = animationProperty.type == Null;
    return result;
  }

  //String
  bool isString(EditableProperty animationProperty) {
    bool result = compareType(animationProperty.type, String);
    return result;
  }

  void setStringValue(EditableProperty animationProperty, dynamic event) {
    animationProperty.setter(event.target.value);
  }

  //bool
  bool isBool(EditableProperty animationProperty) {
    return animationProperty.type == bool;
  }

  void setBoolValue(EditableProperty animationProperty, dynamic event) {
    animationProperty.setter(event.target.checked);
  }

  //int
  bool isInt(EditableProperty animationProperty) {
    return animationProperty.type == int;
  }

  void setIntValue(EditableProperty animationProperty, dynamic event) {
    animationProperty.setter(int.parse(event.target.value as String, onError: (s) => 0));
  }

  //num
  bool isNum(EditableProperty animationProperty) {
    return animationProperty.type == num || animationProperty.type == double;
  }

  void setNumValue(EditableProperty animationProperty, dynamic event) {
    animationProperty.setter(double.parse(event.target.value as String, (s) => 0.0));
  }

  //Function
  bool isFunction(EditableProperty animationProperty) {
    return animationProperty.type == FunctionModel;
  }

  //Custom components

  //Vector2
  bool isVector2(EditableProperty animationProperty) {
    return animationProperty.type == Vector2;
  }

  void setVector2Value(EditableProperty animationProperty, dynamic event) {
    animationProperty.setter(event as Vector2);
  }

  //Vector3
  bool isVector3(EditableProperty animationProperty) {
    return animationProperty.type == Vector3;
  }

  void setVector3Value(EditableProperty animationProperty, dynamic event) {
    animationProperty.setter(event as Vector3);
  }

  //Vector4
  bool isVector4(EditableProperty animationProperty) {
    return animationProperty.type == Vector4;
  }

  void setVector4Value(EditableProperty animationProperty, dynamic event) {
    animationProperty.setter(event as Vector4);
  }

  //Matrix3
  bool isMatrix3(EditableProperty animationProperty) {
    return animationProperty.type == Matrix3;
  }

  void setMatrix3Value(EditableProperty animationProperty, dynamic event) {
    animationProperty.setter(event as Matrix3);
  }

  //Matrix4
  bool isMatrix4(EditableProperty animationProperty) {
    return animationProperty.type == Matrix4;
  }

  void setMatrix4Value(EditableProperty animationProperty, Matrix4 event) {
    animationProperty.setter(event);
  }

  //List
  bool isList(EditableProperty animationProperty) {
    return animationProperty.type.toString() == 'List';
  }

  void setSelection(dynamic event) {
    IEditElement selection;
    if (event is IEditElement) {
      selection = event;
    } else {
      selection = new CustomEditElement(event);
    }
    innerSelectionChange.emit(selection);
  }

  //Map
  bool isMap(EditableProperty animationProperty) {
    return animationProperty.type.toString() == '_InternalLinkedHashMap';
  }

  //isWebGLEnum
  bool isWebGLEnum(EditableProperty animationProperty) {
    return compareType(animationProperty.type, WebGLEnum);
  }

  void setWebGLEnumSelection(EditableProperty animationProperty, dynamic event) {
    animationProperty.setter(event);
  }

  List<WebGLEnum> getWebglEnumItems(Type type) {
    return WebGLEnum.getItems(type);
  }

  //Material
  bool isMaterial(EditableProperty animationProperty) {
    return compareType(animationProperty.type, Material);
  }

  //Texture
  bool isTexture(EditableProperty animationProperty) {
    return compareType(animationProperty.type, Texture);
  }

  //WebGLTexture
  bool isWebGLTexture(EditableProperty animationProperty) {
    return compareType(animationProperty.type, WebGLTexture);
  }

  void setSelectionWebGLTexture(dynamic event) {
    (event as WebGLTexture).edit();
    setSelection(event);
  }

  //WebGLBuffer
  bool isWebGLBuffer(EditableProperty animationProperty) {
    return compareType(animationProperty.type, WebGLBuffer);
  }

  //Mesh
  bool isMesh(EditableProperty animationProperty) {
    return compareType(animationProperty.type, MeshPrimitive);
  }

  //Camera
  bool isCamera(EditableProperty animationProperty) {
    return compareType(animationProperty.type, Camera);
  }

  //Light
  bool isLight(EditableProperty animationProperty) {
    return compareType(animationProperty.type, Light);
  }

  // >> Html

  //ImageElement
  bool isImageElement(EditableProperty animationProperty) {
    bool result = compareType(animationProperty.type, ImageElement);
    if (result) {
//      print('');
    }
    return result;
  }

  void selectTexture(Event event){
    File file = (event.target as FileUploadInputElement).files[0];

    FileReader reader = new FileReader();
    reader
      ..onLoadEnd.listen((_)async {
        ImageElement image = new ImageElement(src : reader.result.toString());
        WebGLTexture currentTexture = application.currentSelection as WebGLTexture;
        currentTexture.image.src = reader.result.toString(); // need this to update current property editor
        currentTexture.image = image;
      });

    if(file != null){
      reader.readAsDataUrl(file);
    }
  }

  // >>

  /// Return true if type is the same or if it's a subType
  bool compareType(Type elementType, Type compareType) {
    ClassMirror elementTypeMirror = reflectClass(elementType);
    ClassMirror compareTypeMirror = reflectClass(compareType);
    bool result = (elementType.toString() != "Null") && elementTypeMirror.isSubtypeOf(compareTypeMirror);
    return result;
  }
}
