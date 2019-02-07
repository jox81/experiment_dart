
class UtilsHttp{

  static const String WEB_PATH_LOCALHOST8080 = 'http://localhost:8080/';
  static const String WEB_PATH_RELATIVE = './';

  // This webPath is used within the webFolder but it can be replaced with 'http://localhost:8080/' to use in unit test
  //This is usefull when using unit tests from port 8081... instead of web:8080 Worked with previous version. but now with dart  2.0 no
  static String _webPath = WEB_PATH_RELATIVE;
  static String get webPath => _webPath;
  static set webPath(String value) {
    _webPath = value;
  }

  static bool _useWebPath = false;
  static set useWebPath(bool value){
    _useWebPath = value;
    if(_useWebPath){
      _webPath = WEB_PATH_LOCALHOST8080;
    }else{
      _webPath = WEB_PATH_RELATIVE;
    }
  }
  static bool get useWebPath => _useWebPath;

  static String getWebPath(String url) {
    String baseWebPath = webPath;
    if(url.startsWith('http://') ||url.startsWith('/') || url.startsWith('./') || url.startsWith('../')){
      baseWebPath = '';
    }else if(url.startsWith('packages')){
      baseWebPath = '${Uri.base.origin}/';
    }

    String fullPath = '${baseWebPath}${url}';
//    print('UtilsAssets.getWebPath fullPath : $fullPath');
    return fullPath;
  }
}
