(temp writing readme.md : https://help.github.com/articles/basic-writing-and-formatting-syntax/)

#some gltf utilities to load data
https://github.com/AnalyticalGraphicsInc/gltf-utilities
js decode64 : https://github.com/AnalyticalGraphicsInc/gltf-utilities/blob/master/gltfUtilities.js

#BASE64
the Base64 format is RFC-4648 : https://tools.ietf.org/html/rfc4648

#Dart decoding using Convert package

dart convert : https://api.dartlang.org/stable/1.24.2/dart-convert/BASE64-constant.html

```dart
import 'dart:convert' show BASE64;

void main () {
    String fullGltfData64String = "data:image/png;base64,AAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAgD8AAAAA";
      String base64GltFPrefix = "data:image/png;base64,";
    
      String baseGltfData64String = fullGltfData64String.substring(base64GltFPrefix.length);
    
      //> decoding
    
      final List<int> base64Decoded = BASE64.decode(baseGltfData64String);
      print(base64Decoded.length);
      print(base64Decoded);
      //[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 63, 0, 0, 0, 0]
    
      List<String> bits = base64Decoded.map((int v) => v.toRadixString(2).padLeft(8,'0')).toList();
      print(bits);
      //[00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 10000000, 00111111, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 00000000, 10000000, 00111111, 00000000, 00000000, 00000000, 00000000]
    
      List<String> bitHex = base64Decoded.map((int v) => '0x${v.toRadixString(16).padLeft(2,'0')}').toList();
      print(bitHex);
      //[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 80, 3f, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 80, 3f, 0, 0, 0, 0]
      List<String> bitHexFormated = base64Decoded.map((int v) => '0x${v.toRadixString(16).padLeft(2,'0')}').toList();
      print(bitHexFormated);
      //[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x3f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x3f, 0x00, 0x00, 0x00, 0x00]
    
      //> encoding
    
      final String base64Encoded = BASE64.encode(base64Decoded);
      print(base64Encoded);
    
      //> compare
    
      print(baseGltfData64String == base64Encoded);
}
```