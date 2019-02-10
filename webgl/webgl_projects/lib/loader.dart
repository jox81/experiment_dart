import 'dart:html';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loader.dart';

/// Un [Loader] permet d'afficher un widget indiquant la progression de chargement.
/// https://www.w3schools.com/howto/howto_css_loader.asp
class LoaderWidget{

  DivElement _divProgressValueElement;
  LoaderWidget(){
    document.head.append(new StyleElement());
    final styleSheet = document.styleSheets[0] as CssStyleSheet;

    DivElement divContainer = createLoader(styleSheet);
    document.body.append(divContainer);
  }

  DivElement createLoader(CssStyleSheet styleSheet) {
    final String containerRule = '''
      .container {
        width: 120px;
        height: 120px;
        position: absolute;
        top:50px;
        left:50px;
      }
    ''';
    styleSheet..insertRule(containerRule, 0);

    final String loaderRule = '''
      .loader {
        border: 15px solid #f3f3f3; /* Light grey */
        border-top: 15px solid #3498db; /* Blue */
        border-radius: 50%;
        width: 90px;
        height: 90px;
        position:absolute;
        top:0px;
        left:0px;
        animation: spin 2s linear infinite;
      }
    ''';
    styleSheet..insertRule(loaderRule, 0);

    final spinAnimationRule = '''
      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
    ''';
    styleSheet..insertRule(spinAnimationRule, 0);

    DivElement loaderContainer = new DivElement()
      ..classes.add("container");

    DivElement loaderElement = new DivElement()
      ..classes.add("loader");

    loaderContainer.append(loaderElement);

    _divProgressValueElement = createProgressValue(styleSheet);
    loaderContainer.append(_divProgressValueElement);

    return loaderContainer;
  }

  DivElement createProgressValue(CssStyleSheet styleSheet) {
    final loaderRule = '''
      .loaderValue {
        border: none;
        width: 120px;
        height: 120px;
        align: center;
        font-size:small;
        position:absolute;
        top:0px;
        left:0px;
        text-align: center;
        vertical-align: middle;
        line-height: 120px; /* 2 lines in the text but this force 2nd to go uneder loader*/
      }
    ''';
    styleSheet..insertRule(loaderRule, 0);

    DivElement divElement = new DivElement()
      ..classes.add("loaderValue")
      ..appendText("0%");

    return divElement;
  }

  void show(){

  }

  void hide(){

  }

  /// le ProgressEvent viendra lors de request.onProgress
  void showProgress(LoadProgressEvent loadProgressEvent){
    _divProgressValueElement.innerHtml = '${(Loader.loadedSize / Loader.totalFileSize * 100).toStringAsFixed(2)} % <br/> ${(Loader.loadedSize / 1024/1024).toStringAsFixed(2)}Mo / ${(Loader.totalFileSize/1024/1024).toStringAsFixed(2)}Mo';
    print('Loaded : ${Loader.totalFileCount} files : ${(Loader.loadedSize / Loader.totalFileSize * 100).toStringAsFixed(2)} % : ${Loader.loadedSize} / ${Loader.totalFileSize}');
  }
}