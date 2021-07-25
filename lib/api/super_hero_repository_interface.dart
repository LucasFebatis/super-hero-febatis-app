

import 'package:app/model/super_hero.dart';

abstract class ISuperHeroRepository {
  Future<List<SuperHero>> getAll();
}