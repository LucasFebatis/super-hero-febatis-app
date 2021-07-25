import 'package:app/api/super_hero_repository.dart';
import 'package:app/api/super_hero_repository_interface.dart';
import 'package:app/model/super_hero.dart';
import 'package:dio/dio.dart';

class HomeController {
  final ISuperHeroRepository superHeroRepository = SuperHeroRepository(Dio());

  Future<List<SuperHero>> getAll() {
    return superHeroRepository.getAll();
  }
}