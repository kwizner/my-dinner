import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'package:my_dinner/core/services/injection.dart';
import 'package:my_dinner/core/services/utils/demo.dart';
import 'package:my_dinner/features/my_diet/data/dtos/diet_dto.dart';

abstract class MyDietApi {
  Future<List<DietDto>> getDiets(DateTime day);
}

@RegisterAs(MyDietApi)
@singleton
class MyDietApiHttp implements MyDietApi {
  MyDietApiHttp();

  @override
  Future<List<DietDto>> getDiets(DateTime day) async {
    throw UnimplementedError();
  }
}

@RegisterAs(MyDietApi, env: Env.demo)
@singleton
class MyDietApiDemo implements MyDietApi {
  @override
  Future<List<DietDto>> getDiets(DateTime day) async {
    await DemoUtils.smallDelay;
    String response;
    if (day.day % 2 == 0) {
      response = await rootBundle.loadString('assets/demo/diets.json');
    } else {
      response = await rootBundle.loadString('assets/demo/empty_array.json');
    }

    // throw Exception();
    return json.decode(response).map<DietDto>((e) => DietDto.fromJson(e)).toList();
  }
}
