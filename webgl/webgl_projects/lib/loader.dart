import 'dart:html';

/// Un [Loader] permet d'afficher un widget indiquant la progression de chargement.
/// https://www.w3schools.com/howto/howto_css_loader.asp
class Loader{

  Loader(){
    document.head.append(new StyleElement());
    final styleSheet = document.styleSheets[0] as CssStyleSheet;

    DivElement divProgressBarElement = createProgressBar(styleSheet);
    document.body.append(divProgressBarElement);

    DivElement divProgressValueElement = createProgressValue(styleSheet);
    document.body.append(divProgressValueElement);
  }

  DivElement createProgressBar(CssStyleSheet styleSheet) {
    final loaderRule = '''
      .loader {
        border: 16px solid #f3f3f3; /* Light grey */
        border-top: 16px solid #3498db; /* Blue */
        border-radius: 50%;
        width: 120px;
        height: 120px;
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

    DivElement divElement = new DivElement()
      ..classes.add("loader");

    return divElement;
  }

  DivElement createProgressValue(CssStyleSheet styleSheet) {
    final loaderRule = '''
      .loaderValue {
        border: none;
        width: 120px;
        height: 120px;
        align: center;
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
  void showProgress(ProgressEvent progressEvent){
    num percentProgression = progressEvent.loaded / progressEvent.total * 100;
    print('percentProgression : $percentProgression');
  }
}