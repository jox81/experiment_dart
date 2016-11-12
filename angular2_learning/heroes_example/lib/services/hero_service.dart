import 'dart:async';
import 'dart:convert';
import 'package:angular2/core.dart';

import 'package:angular2_learning/models/hero.dart';
import 'package:http/http.dart';

@Injectable()
class HeroService {
  static const _heroesUrl = 'app/heroes'; // URL to web API

  final Client _http;

  HeroService(this._http);

  Future<List<Hero>> getHeroes() async {
    try {
      final response = await _http.get(_heroesUrl);
      final heroes = _extractData(response)
          .map((value) => new Hero.fromJson(value))
          .toList();
      return heroes;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Hero> getHero(int id) async =>
      (await getHeroes()).firstWhere((hero) => hero.id == id);

  dynamic _extractData(Response resp) => JSON.decode(resp.body)['data'];

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return new Exception('Server error; cause: $e');
  }

}
