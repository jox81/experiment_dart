import 'package:angular2/core.dart';
import 'package:angular2_learning/models/hero.dart';

@Component(
    selector: 'my-hero-detail',
    templateUrl: 'hero_detail_component.html',
    styleUrls: const ['hero_detail_component.css']
)

class HeroDetailComponent {
  @Input()
  Hero hero;
}
