import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:online_shopping/models/non_veg_model.dart';

Future<DataProvider> loadNonVegData() async {
  try {
    final String jsonString =
        await rootBundle.loadString('assets/data/non_veg_data.json');

    final jsonData = json.decode(jsonString);

    if (jsonData is Map<String, dynamic>) {
      DataProvider dataProvider = DataProvider.fromJson(jsonData);
      return dataProvider;
    } else {
      throw Exception('Expected JSON to be a Map but got ${jsonData.runtimeType}');
    }
  } catch (e) {
    rethrow;
  }
}
