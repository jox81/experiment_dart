import 'package:reflectable/reflectable.dart';
import 'package:webgl/src/introspection/custom_edit_element.dart';
import 'package:webgl/src/introspection/editable_property.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'reflector.dart';

//@reflector
abstract class IEditElement {
  String name;

  Map<String, EditableProperty> _properties;
  Map<String, EditableProperty> get properties {
    if (_properties == null) {
      _properties = getPropertiesInfos();
    }
    return _properties;
  }

  Map<String, EditableProperty> getPropertiesInfos() {
    dynamic elementToCheck = this;
    if (this is CustomEditElement) {
      elementToCheck = (this as CustomEditElement).element;
    }
    return IntrospectionManager.instance.getPropertiesInfos(elementToCheck);
  }

  void edit(){}

  ///From : http://stackoverflow.com/questions/20024298/add-json-serializer-to-every-model-class
  ///The toJson method is necessary to use JSON.encode(..)
  Map toJson() {
    Map map = new Map<String, dynamic>();

    InstanceMirror im = reflector.reflect(this);
    ClassMirror cm = im.type;

    var decls = cm.declarations.values.where((dm) => dm is VariableMirror);
    decls.forEach((dm) {
      String key = dm.simpleName;
      dynamic val = im.invokeGetter(dm.simpleName);
      map[key] = val;
    });

    return map;
  }
}