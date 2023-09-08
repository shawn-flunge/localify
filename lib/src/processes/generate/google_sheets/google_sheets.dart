

import 'dart:convert';
import 'dart:io';

import 'package:localify/src/configuration.dart';
import 'package:localify/src/processes/generate/utils/escapes.dart';
import 'package:localify/src/types.dart' show Rows;


part 'process.dart';
part 'generate.dart';

typedef Language = ({int index, String locale});

Future<bool> generateOutputsFromGoogleSheetsData(Configuration config, String rawData) async{

  print('process start');

  final Map body = json.decode(rawData);
  final Rows<dynamic> rows = body['valueRanges'][0]['values'].cast<List<dynamic>>();

  final (keyIndex, languages) = _parseTableHeader(rows.first);
  _fillEmptyCells(rows);

  final sources = _parseToLanguageMap(config.isCompact, rows, keyIndex, languages);
  final bool success = await _generateFromSource(config, sources);

  return success;
}





