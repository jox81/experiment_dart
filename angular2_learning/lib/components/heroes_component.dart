import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2_learning/components/hero_detail_component.dart';
import 'package:angular2_learning/models/hero.dart';
import 'package:angular2_learning/services/hero_service.dart';

@Component(
    selector: 'my-heroes',
    templateUrl: 'heroes_component.html',
    styleUrls: const ['heroes_component.css'],
    directives: const [HeroDetailComponent]
)

class HeroesComponent implements OnInit {

  final HeroService _heroService;

  List<Hero> heroes;
  Hero selectedHero;

  HeroesComponent(this._heroService);

  onSelect(Hero hero) {
    selectedHero = hero;
  }

  Future getHeroes() async {
    heroes = await _heroService.getHeroes();
  }

  void ngOnInit() {
    getHeroes();
  }
}
