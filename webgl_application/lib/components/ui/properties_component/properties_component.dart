import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:node_engine/src/nodes/custom/node_getter.dart';
import 'package:node_engine/src/nodes/custom/node_setter.dart';
import 'package:reflectable/reflectable.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/accessor.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/renderer/materials.dart';
import 'package:webgl/src/gltf/mesh_primitive.dart';
import 'package:webgl/src/gltf/scene.dart';
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
import 'package:webgl/src/animation/animation_property.dart' hide PropertyGetter, PropertySetter;
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/light/light.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart';
import 'package:webgl/src/webgl_objects/webgl_active_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl_application/src/application.dart';
import 'package:webgl/src/introspection.dart';
import 'package:angular_forms/angular_forms.dart' as forms;

@Component(
    selector: 'properties',
    templateUrl: 'properties_component.html',
    styleUrls: const [
      'properties_component.css'
    ],
    directives: const <dynamic>[
      coreDirectives,
      forms.formDirectives,
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

  CustomEditElement _iEditElement;
  @Input()
  set iEditElement(CustomEditElement value) => _iEditElement = value;
  CustomEditElement get iEditElement => _iEditElement;

  final _innerSelectionChange = new StreamController<dynamic>.broadcast();

  @Output()
  Stream get innerSelectionChange => _innerSelectionChange.stream;

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
    animationProperty.setter(int.tryParse(event.target.value as String) ?? 0);
  }

  //num
  bool isNum(EditableProperty animationProperty) {
    return animationProperty.type == num || animationProperty.type == double;
  }

  void setNumValue(EditableProperty animationProperty, dynamic event) {
    animationProperty.setter(double.tryParse(event.target.value as String) ?? 0.0);
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
    CustomEditElement selection;
    if (event is CustomEditElement) {
      selection = event;
    } else {
      selection = new CustomEditElement(event);
    }

    selection.edit();

    _innerSelectionChange.add(selection);
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

  bool _isEditable(EditableProperty animationProperty,Type type) {
    return compareType(animationProperty.type, type);
  }

  bool isEditable(EditableProperty animationProperty) {
    return
      _isEditable(animationProperty, RawMaterial) ||
      _isEditable(animationProperty, Texture) ||
      _isEditable(animationProperty, WebGLTexture) ||
      _isEditable(animationProperty, WebGLBuffer) ||
      _isEditable(animationProperty, MeshPrimitive) ||
      _isEditable(animationProperty, Camera) ||
      _isEditable(animationProperty, Light) ||
      _isEditable(animationProperty, GLTFAccessor) ||
      _isEditable(animationProperty, GLTFBufferView) ||
      _isEditable(animationProperty, GLTFBuffer) ||
      _isEditable(animationProperty, GLTFScene) ||
      _isEditable(animationProperty, GLTFNode) ||
      _isEditable(animationProperty, GLTFMesh);
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
    ClassMirror elementTypeMirror;
    ClassMirror compareTypeMirror;

    if(reflector.canReflectType(elementType)){
      elementTypeMirror = reflector.reflectType(elementType);
    }

    if(reflector.canReflectType(compareType)){
      compareTypeMirror = reflector.reflectType(compareType);
    }

    bool result;

    if(elementTypeMirror != null && compareTypeMirror != null ){
      try{
        result = elementTypeMirror.isSubtypeOf(compareTypeMirror);
      } catch (e) {
        result = false;
      }

    }else{
      result = elementType == compareType;
    }
    return (elementType.toString() != "Null") && result;

//    elementTypeMirror = reflector.reflectType(elementType);
//    compareTypeMirror = reflector.reflectType(compareType);
//    return (elementType.toString() != "Null") && elementTypeMirror.isSubtypeOf(compareTypeMirror);
  }

  //Getter/Setter button
  void getterClicked(Event e, PropertyGetter<dynamic> getter, CustomEditElement iEditElement){
    new NodeGetter<dynamic>(getter)
    ..referencedOject = iEditElement;
  }
  void setterClicked(Event e, PropertySetter<dynamic> setter, CustomEditElement iEditElement){
    new NodeSetter<dynamic>(setter)
      ..referencedOject = iEditElement;
  }

  void print(dynamic data){
    print(data);
  }
}
