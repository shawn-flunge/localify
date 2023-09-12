

import 'dart:convert';

import 'package:localify/src/configuration.dart';
import 'package:localify/src/processes/generate/utils/escapes.dart';
import 'package:localify/src/processes/generate/utils/generate_outputs.dart';
import 'package:localify/src/types.dart';


part 'process.dart';

typedef Language = ({int index, String locale});

Future<bool> generateOutputsFromGoogleSheetsData(Configuration config, String rawData) async{

  print('process start');

  final Map body = json.decode(rawData);
  final Rows<dynamic> rows = body['valueRanges'][0]['values'].cast<List<dynamic>>();

  final (keyIndex, languages) = _parseTableHeader(rows.first);
  _fillEmptyCells(rows);

  final sources = _parseToLanguageMap(config.isCompact, rows, keyIndex, languages);
  final bool success = await generateFromSource(sources, config);

  return success;
}





