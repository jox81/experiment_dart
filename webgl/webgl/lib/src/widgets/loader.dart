import 'dart:html';

/// Un [LoaderWidget] permet d'afficher un widget indiquant la progression de chargement.
/// https://www.w3schools.com/howto/howto_css_asp
class LoaderWidget{

  DivElement _divContainer;
  DivElement _divProgressValueElement;
  LoaderWidget(){
    document.head.append(new StyleElement());
    final styleSheet = document.styleSheets.last as CssStyleSheet;

    _divContainer = createLoader(styleSheet);
    document.body.append(_divContainer);
  }

  DivElement createLoader(CssStyleSheet styleSheet) {
    final String containerRule = '''
      .container {
        width: 120px;
        height: 120px;
        position: absolute;
        top:100px;
        left:50px;
        display:none;
      }
    ''';
    styleSheet..insertRule(containerRule);

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
    styleSheet..insertRule(loaderRule);

    final spinAnimationRule = '''
      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
    ''';
    styleSheet..insertRule(spinAnimationRule);

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
    _divContainer.style.display = 'block';
  }

  void hide(){
    _divContainer.style.display = 'none';
  }

  /// le ProgressEvent viendra lors de request.onProgress
  void showProgress(int loadedSize, int totalFileSize, int totalFileCount){
    _divProgressValueElement.innerHtml = '${(loadedSize / totalFileSize * 100).toStringAsFixed(2)} % <br/> ${(loadedSize / 1024/1024).toStringAsFixed(2)}Mo / ${(totalFileSize/1024/1024).toStringAsFixed(2)}Mo';
    print('Loaded : ${totalFileCount} files : ${(loadedSize / totalFileSize * 100).toStringAsFixed(2)} % : ${loadedSize} octets / ${totalFileSize} octets');
  }
}