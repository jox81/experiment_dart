import 'package:angular/angular.dart';

@Component(
    selector: 'parameterName',
    templateUrl: 'parameter_name_component.html',
    styleUrls: const ['parameter_name_component.css']
)
class ParameterNameComponent {

  @Input()
  String name;
}