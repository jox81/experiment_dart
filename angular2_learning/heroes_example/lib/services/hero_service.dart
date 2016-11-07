import 'dart:async';
import 'package:angular2/core.dart';

import 'mock_heroes.dart';
import 'package:angular2_learning/models/hero.dart';

@Injectable()
class HeroService {
  Future<List<Hero>> getHeroes() async => mockHeroes;

  Future<Hero> getHero(int id) async =>
      (await getHeroes()).firstWhere((hero) => hero.id == id);

}
