
part of 'google_sheets.dart';


(int key, List<Language> languages) _parseTableHeader(List<dynamic> columnNames){
  final List<Language> locales = [];
  final int key = columnNames.indexWhere((element) => element.toString().toUpperCase() == 'KEY');

  for(int i=key+1; i<columnNames.length; i++){
    final String value = columnNames[i];
    if(i == key) continue;
    if(value.isNotEmpty) locales.add((index: i, locale: value));
  }

  return (key, locales);
}


void _fillEmptyCells(List<List<dynamic>> values){

  final columnCount = values.first.length;

  for(int i=1; i<values.length; i++){
    if(values[i].length != columnCount){
      values[i].expandTo(columnCount, '');
    }
  }
}


/// _parseToLanguageMap
LanguageMap _parseToLanguageMap(bool compactMode, Rows rows, int keyIndex, List<Language> languages) {
  final LanguageMap result = {};

  /// result에 language code 추가
  for(var lang in languages){
    result.putIfAbsent(lang.locale, () => {});
  }


  for (int i=1; i<rows.length; i++) {
    late Map<String, dynamic> properties;
    final String key = rows[i][keyIndex];

    if(key.isEmpty){
      continue;
    }

    try{
      if(compactMode == false && rows[i+1][keyIndex].isEmpty){
        properties = _parseProperties(rows, i, keyIndex, languages);
      } else {
        properties = {};
      }
    } catch(e){
      properties = {};
    }

    for (int j = keyIndex+1; j < rows[i].length; j++) {
      final languageCode = rows[0][j];
      result[languageCode]?.putIfAbsent('@@locale', () => languageCode);

      final value = rows[i][j].toString().replaceAllMapped(Escapes.regExp, (mapped){
        final target = mapped.input.substring(mapped.start, mapped.end);
        final escape = Escapes.fromCodes(target.codeUnits);

        return switch(escape){
          Escapes.backSlash => '\\\\',
          Escapes.newLine => '\\n',
          Escapes.hardNewLine => target,
          Escapes.doubleQuotes => '\\"'
        };
      });


      result[languageCode]?.putIfAbsent(key, () => value);
      if(properties.isNotEmpty){
        result[languageCode]?.putIfAbsent('@$key', () => properties);
      }
    }
  }

  return result;
}


Map<String, dynamic> _parseProperties(Rows rows, int targetRowIndex, int keyIndex, List<Language> languages) {

  int nextRowIndex = targetRowIndex+1;

  if(rows.length <= nextRowIndex){
    // todo : 알림
    throw 'if there is a row which doesn\'t have a property and starts with @, please remove @ // index is $targetRowIndex';
  }

  while(rows[nextRowIndex][keyIndex].isEmpty) {
    nextRowIndex++;
  }

  final Map<String, dynamic> properties = {};

  final range = rows.getRange(targetRowIndex+1, nextRowIndex).toList();
  while(range.isNotEmpty){
    properties.addAll( recursive(range, 0, {}, -1, languages.first.index) );
  }

  return properties;
}

/// this could be reused in other processes
recursive(Rows range, int i, Map<String, dynamic> accumulated, int preDepth, int first){
  final row = Map.from(range[i].asMap())..removeWhere((key, value) => value.isEmpty);


  final depth = row.keys.first;
  final values = row.values;

  // print('\n============cycle starts====================');
  // print('$i row : $row // $preDepth, $depth //');

  if((depth <= preDepth) && (depth == first)) {
    // print('🦊 depth overflow');
    // return accumulated;
    accumulated.clear();
    return <String, dynamic>{};
  }

  if(row.length == 1){

    final Map<String, dynamic> thisDepth = {};
    final Map<String, dynamic> parsedRow = {values.first : {}};

    /// prevent out of range error
    if(range.length <= i+1){
      /// todo : 에러 메시지 다듬기
      throw 'There is a wrong structure at properties of "A"';
    }

    // print('홀 $i / $parsedRow / ${range[i]}');

    final child = recursive(range, i+1, thisDepth, depth, first);

    // print('parents : $parsedRow // child : $child');
    parsedRow[values.first].addAll(child);
    parsedRow.addAll(thisDepth);
    // parsedRow.putIfAbsent(values.first, () => child);

    if(depth < preDepth){
      accumulated.addAll(parsedRow);
      range.removeAt(i);
      // print('#$i left is $range // accumulated : $accumulated');
      return <String, dynamic>{};
    }



    range.removeAt(i);
    // print('#$i left is $range');
    return parsedRow;
  } else {

    final Map<String, dynamic> parsedRow = {values.first: values.last};


    /// prevent out of range error
    if(range.length <= i+1){
      // print('r.l : ${range.length} <= ${i+1} // $depth < $preDepth}');
      range.removeAt(i);
      if(depth < preDepth){
        accumulated.addAll(parsedRow);

        return <String, dynamic>{};
      }
      return parsedRow;
    }


    // print('짝 $i / $parsedRow / ${range[i]}');



    final next = recursive(range, i+1, accumulated, depth, first);
    // print('current $parsedRow // next: $next');



    if(depth < preDepth){
      accumulated.addAll(parsedRow);
      range.removeAt(i);
      // print('#$i left is $range');
      return <String, dynamic>{};
    }

    parsedRow.addAll(next);

    range.removeAt(i);
    // print('#$i left is $range');
    return parsedRow;
  }

}





extension _ListExtenstion<T> on List<T>{

  void expandTo(int to, T value){
    while(length < to){
      add(value);
    }
  }
}