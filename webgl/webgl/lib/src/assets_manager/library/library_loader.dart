import 'package:webgl/src/assets_manager/loader.dart';

class LibraryLoader{
  final String filePath;
  final Loader loader;

  LibraryLoader(this.filePath, this.loader);

  Future<dynamic> load() async => await loader.load(filePath);
  dynamic loadSync() => loader.loadSync(filePath);
  Future<int> getFileSize() async => await loader.getFileSize(filePath);
}