


import 'dart:convert';

import 'package:localify/localify.dart';
import 'package:localify/src/processes/generate/utils/escapes.dart';
import 'package:localify/src/types.dart' show Rows;

Future<bool> generateOutputsFromNotionDatabase(Configuration config, String rawData) async{

  /// source
  final Map body = json.decode(rawData);
  final List results = body['results'];

  /// parse header
  final header = _parseTableHeader(results[0]['properties'].keys);
  final rows = _parseRows<(String locale, String value)>(results);

  return false;
}


Map<String, Map<String, dynamic>> _parseTableHeader(Iterable<String> languages){
  final Map<String, Map<String, dynamic>> result = {};

  for(var lang in languages){
    result.putIfAbsent(lang, () => {});
  }
  return result;
}


Rows<T> _parseRows<T>(List body){
  final escape = Escapes.replace;

  final Rows<T> rows = body.getRange(0, body.length).map((e) {

    final Map properties = e['properties'];
    final List<T> row = [];

    properties.forEach((key, value) {
      final type = value['type'];
      final text = value[type];
      row.add(
          (key, text.isEmpty ? '' : escape(text[0]['plain_text'])) as T
      );
    });

    return row;
  }).toList();

  return rows;
}