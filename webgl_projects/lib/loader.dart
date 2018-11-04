import 'dart:html';

/// Un [Loader] permet d'afficher un widget indiquant la progression de chargement.
/// https://www.w3schools.com/howto/howto_css_loader.asp
class Loader{
  DivElement _divElement;

  Loader(){
    _divElement = new DivElement()
    ..classes.add("loader");

    document.head.append(new StyleElement());
    final styleSheet = document.styleSheets[0] as CssStyleSheet;
    final rule = '''
      .loader {
        border: 16px solid #f3f3f3; /* Light grey */
        border-top: 16px solid #3498db; /* Blue */
        border-radius: 50%;
        width: 120px;
        height: 120px;
        animation: spin 2s linear infinite;
      }
    ''';
    styleSheet..insertRule(rule, 0);
    final rule2 = '''
      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
    ''';
    styleSheet..insertRule(rule2, 0);

    document.body.append(_divElement);
  }

  void showProgress(ProgressEvent progressEvent){
    num total = progressEvent.total;
    num loaded = progressEvent.loaded;
    num percentProgrssion = loaded / total * 100;
    // Todo (jpu) : do something with this
  }
}