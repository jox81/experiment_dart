import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2_learning/components/hero_detail_component.dart';
import 'package:angular2_learning/components/heroes_component.dart';
import 'package:angular2_learning/models/hero.dart';
import 'package:angular2_learning/services/hero_service.dart';
import 'package:angular2/router.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const [HeroesComponent, ROUTER_DIRECTIVES],
    providers: const [HeroService, ROUTER_PROVIDERS]
)

class AppComponent{
  String title = 'Tour of Heroes';
}
