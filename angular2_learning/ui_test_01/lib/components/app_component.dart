import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const [materialDirectives],
    providers: materialProviders
)
class AppComponent {
  String title = "UI Test 01 : angular2_components";

  int count = 0;

  bool allowed = true;

  List<String> reorderItems = ["First", "Second", "Third"];

  void increment() {
    count++;
  }

  void onReorder(ReorderEvent reorder) {
    reorderItems.insert(
        reorder.destIndex, reorderItems.removeAt(reorder.sourceIndex));
  }

  void reset() {
    count = 0;
  }
}