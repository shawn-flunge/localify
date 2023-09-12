
import 'dart:io';

import 'package:localify/src/configuration.dart';
import 'package:localify/src/types.dart';

const _tab = '\t';
const _new = '\n';

Future<bool> generateFromSource(LanguageMap languages, Configuration config) async{
  try{
    final directory = await Directory(config.outputDir).create(recursive: true);

    for (var element in languages.entries) {
      final file = File('${directory.path}/${element.key}.${config.outputExtension}');
      final sink = file.openWrite();
      sink.write(element.value.asJson());
      sink.close();
    }

    return true;
  } catch(e) {

    return false;
  }
}


extension _MapExtension on Map{

  void forEachWithIndex(void Function(String key, dynamic value, int index) action){
    final keyList = keys.toList();
    final valueList = values.toList();
    for(int i=0; i<length; i++){
      action(keyList[i], valueList[i], i);
    }
  }

  /// Parse a raw String in json format from a Dart Map Object
  String asJson() => _mapToJsonString(this, 1);

  String _mapToJsonString(Map map, int depth){
    String result = '{$_new';

    map.forEachWithIndex((key, value, i) {
      final comma = i != map.length-1 ? ',' : '';

      if(value is String){
        result += '${_tab*depth}"$key": "$value"$comma$_new';
      } else{
        result += '${_tab*depth}"$key": ${_mapToJsonString(value, depth+1)}$comma$_new';
      }
    });
    result += '${_tab*(depth-1)}}';

    return result;
  }

}

