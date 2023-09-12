


import 'dart:convert';

import 'package:localify/localify.dart';
import 'package:localify/src/processes/generate/utils/escapes.dart';
import 'package:localify/src/processes/generate/utils/generate_outputs.dart';
import 'package:localify/src/types.dart';

typedef LocalePair = ({String locale, String value});

Future<bool> generateOutputsFromNotionDatabase(Configuration config, String rawData) async{

  /// source
  final Map body = json.decode(rawData);
  final List results = body['results'];
  final rows = _parseRows(results);

  final languages = _parseToLanguageMap(rows);

  final success = await generateFromSource(languages, config);

  return false;
}


Rows<LocalePair> _parseRows(List body){
  final escape = Escapes.replace;

  final Rows<LocalePair> rows = body.getRange(0, body.length).map((e) {

    final Map properties = e['properties'];
    final List<LocalePair> row = [];

    properties.forEach((key, value) {
      final type = value['type'];
      final text = value[type];
      row.add(
          (locale: key, value: text.isEmpty ? '' : escape(text[0]['plain_text']))
      );
    });

    return row;
  }).toList();

  return rows;
}

LanguageMap _parseToLanguageMap(Rows rows){

  final LanguageMap result = {};

  for(var lang in rows[0]){
    if(lang.locale.toUpperCase() == 'KEY') continue;
    result.putIfAbsent(lang.locale, () => {});
    result[lang.locale]!.putIfAbsent('@@locale', () => lang.locale);
  }

  for (var row in rows) {
    final keyIndex = row.indexWhere((element) => element.locale.toUpperCase() == 'KEY');
    final key = row.removeAt(keyIndex);

    for (var cell in row) {
      result[cell.locale]?.putIfAbsent(key.value, () => cell.value);
    }
  }

  return result;
}