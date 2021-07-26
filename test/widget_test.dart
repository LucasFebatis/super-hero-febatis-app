import 'dart:convert';

import 'package:app/controller/home_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([Dio, HomeController])
main() {
  var mockJson = '''
  [
    {
        "id": 1,
        "name": "A-Bomb",
        "slug": "1-a-bomb",
        "powerstats": {
            "intelligence": 38,
            "strength": 100,
            "speed": 17,
            "durability": 80,
            "power": 24,
            "combat": 64
        },
        "appearance": {
            "gender": "Male",
            "race": "Human",
            "height": [
                "6'8",
                "203 cm"
            ],
            "weight": [
                "980 lb",
                "441 kg"
            ],
            "eyeColor": "Yellow",
            "hairColor": "No Hair"
        },
        "biography": {
            "fullName": "Richard Milhouse Jones",
            "alterEgos": "No alter egos found.",
            "aliases": [
                "Rick Jones"
            ],
            "placeOfBirth": "Scarsdale, Arizona",
            "firstAppearance": "Hulk Vol 2 #2 (April, 2008) (as A-Bomb)",
            "publisher": "Marvel Comics",
            "alignment": "good"
        },
        "work": {
            "occupation": "Musician, adventurer, author; formerly talk show host",
            "base": "-"
        },
        "connections": {
            "groupAffiliation": "Hulk Family; Excelsior (sponsor), Avengers (honorary member); formerly partner of the Hulk, Captain America and Captain Marvel; Teen Brigade; ally of Rom",
            "relatives": "Marlo Chandler-Jones (wife); Polly (aunt); Mrs. Chandler (mother-in-law); Keith Chandler, Ray Chandler, three unidentified others (brothers-in-law); unidentified father (deceased); Jackie Shorr (alleged mother; unconfirmed)"
        },
        "images": {
            "xs": "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/images/xs/1-a-bomb.jpg",
            "sm": "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/images/sm/1-a-bomb.jpg",
            "md": "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/images/md/1-a-bomb.jpg",
            "lg": "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/images/lg/1-a-bomb.jpg"
        }
    }
]
  ''';
  group('Teste da Api', () {
    test('Request de sucesso', () async {
      var mockDio = MockDio();
      var homeController = HomeController(mockDio);

      when(mockDio.get('https://akabab.github.io/superhero-api/api/all.json'))
          .thenAnswer(
        (realInvocation) async => Response(
          data: jsonDecode(mockJson),
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      var all = await homeController.getAll();

      expect(all.length, 1);
    });

    test('Request de falha', () async {
      var mockDio = MockDio();
      var homeController = HomeController(mockDio);

      when(mockDio.get('https://akabab.github.io/superhero-api/api/all.json'))
          .thenAnswer(
        (realInvocation) async => Response(
          data: {'message': 'Nenhum obj encontrado'},
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      expect(homeController.getAll(), throwsException);
    });
  });
}
