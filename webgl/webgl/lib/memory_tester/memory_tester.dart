import 'dart:html';
import 'package:webgl/src/webgl_objects/context.dart';

typedef ConstructNewItem<T> = T Function();
typedef void DisposeItem(int i);

class MemoryTester<T>{
  List<T> items;
  ConstructNewItem<T> constructNewItem;
  DisposeItem disposeItem;

  void construct(int count) {
    items ??= new List<T>();

    window.console.time('MemoryTester : construct');

    for (var i = 0; i < count; ++i) {
      items.add(constructNewItem());
    }

    window.console.timeEnd('MemoryTester : construct');
    print('constructed $count : ${items.length}');
  }

  void dispose() {
    if(items != null) {

      window.console.time('MemoryTester : dispose');

      for (int i = 0; i < items.length; ++i) {
        disposeItem(i);
      }

      items.clear();
      items = null;
      items = new List();

      window.console.timeEnd('MemoryTester : dispose');
      print('disposed');
    }
  }

  Future initialize() async {

    InputElement countInput = querySelector('#count') as InputElement;
    InputElement constructButton = querySelector('#construct') as InputElement;
    InputElement disposeButton = querySelector('#dispose') as InputElement;

    CanvasElement canvas = new CanvasElement();
    new Context(canvas);

    constructButton.onClick.listen((_){
      if(countInput.value != '') {
        construct(int.parse(countInput.value));
      }
    });

    disposeButton.onClick.listen((_){
      dispose();
    });
  }
}