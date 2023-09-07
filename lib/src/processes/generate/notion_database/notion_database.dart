


import 'dart:convert';

import 'package:localify/localify.dart';

Future<bool> generateOutputsFromNotionDatabase(Configuration config, String rawData) async{

  /// source
  final Map body = json.decode(rawData);
  final List results = body['results'];

  /// parse header
  final header = _parseTableHeader(results[0]['properties'].keys);

  return false;
}


Map<String, Map<String, dynamic>> _parseTableHeader(Iterable<String> languages){
  final Map<String, Map<String, dynamic>> result = {};

  for(var lang in languages){
    result.putIfAbsent(lang, () => {});
  }
  return result;
}