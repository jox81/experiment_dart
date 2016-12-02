import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';

@Component(
    selector: 'matrix4',
    templateUrl: 'matrix4_component.html',
    styleUrls: const ['matrix4_component.css']
)
class Matrix4Component {

  @Input()
  Matrix4 matrix;

  @Output()
  EventEmitter change = new EventEmitter<Vector3>();

  updateX(event) {
  }
}