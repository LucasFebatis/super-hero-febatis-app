import 'dart:convert';

import 'package:app/api/super_hero_repository_interface.dart';
import 'package:app/model/super_hero.dart';
import 'package:dio/dio.dart';

class SuperHeroRepository implements ISuperHeroRepository {
  final Dio dio;

  SuperHeroRepository(this.dio);

  @override
  Future<List<SuperHero>> getAll() async {
    final response =
        await dio.get('https://akabab.github.io/superhero-api/api/all.json');

    if (response.statusCode == 200) {
      return List<SuperHero>.from(response.data.map((model) => SuperHero.fromJson(model)));
    } else {
      throw Exception('Failed to load super hero list');
    }
  }
}
