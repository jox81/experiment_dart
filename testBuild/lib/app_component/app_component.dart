import 'package:angular2/core.dart';
import 'package:testBuild/introspection.dart';
import 'package:testBuild/model.dart';
import 'package:testBuild/properties_component/properties_component.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const [PropertiesComponent]
)
class AppComponent implements OnInit{

  String infos;

  IEditElement _currentElement;
  IEditElement get currentElement {
    return _currentElement;
  }

  @override
  ngOnInit() async {

    Triangle triangle = new Triangle()
    ..name = 'theTriangle';

    Cube cube = new Cube()
    ..name = 'theCube';

    CustomModel customModel = new CustomModel();

    infos = fillInfos([triangle, cube, customModel]);
    print(infos);

    _currentElement = triangle;
  }

  String fillInfos(List<IEditElement> elements){

    StringBuffer sb = new StringBuffer();

    for(var item in elements){
      sb.write('#############################\n');
      item.getPropertiesInfos().forEach((k, v){
//        sb.write('isFunction : ${v.type == Function} \n');
        sb.write('$k : ${v.type == Function ? v : v.getter()} \n');
      });
    }

    return sb.toString();
  }
}
