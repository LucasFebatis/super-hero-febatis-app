import 'package:app/api/super_hero_repository.dart';
import 'package:app/api/super_hero_repository_interface.dart';
import 'package:app/model/super_hero.dart';
import 'package:dio/dio.dart';

class HomeController {
  late ISuperHeroRepository superHeroRepository;

  HomeController(Dio dio) {
    superHeroRepository = SuperHeroRepository(dio);
  }

  Future<List<SuperHero>> getAll() {
    return superHeroRepository.getAll();
  }
}
