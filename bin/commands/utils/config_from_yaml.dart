

import 'dart:io';


import 'package:localify/src/configuration.dart';
import 'package:localify/src/constants.dart';
import 'package:yaml/yaml.dart';

typedef ProcessYamlNodeCallback = void Function(dynamic parsed);

Future<Configuration> parseConfigurationFromYaml(String path, bool isCompact) async{
  try{
    final File file = File(path);
    final String contents = await file.readAsString();
    final YamlMap? yaml = loadYaml(contents);

    if(yaml == null) throw _YamlIsNullException();
    final YamlMap? target = yaml[programName];
    if(target == null) throw 'Make sure whether you wrote settings correctly or not';
    final config = target.asMap();

    return Configuration.fromYaml(config)..isCompact=isCompact;
  } on PathNotFoundException catch(e){
    print('Can\'t find "localify.yaml" so try to find in pubspec.yaml');
    return parseConfigurationFromYaml('pubspec.yaml', isCompact);
  } on _YamlIsNullException catch(e){

    print('Can\'t find your setting in $path so try again in pubspec.yaml\n$e');
    // rethrow;
    return parseConfigurationFromYaml('pubspec.yaml', isCompact);
  }
}

class _YamlIsNullException implements Exception{
  _YamlIsNullException([this.message = 'There is nothing to read in your Yaml file']);

  final String message;
  @override
  String toString() => 'There is nothing to read in your Yaml file';
}


extension on YamlNode{

  /// parse YamlMap to DartMap
  Map<String, dynamic> asMap(){
    final Map<String, dynamic> map = {};
    final yamlMap = this as YamlMap;

    yamlMap.forEach((key, value) {
      _processNode(value, (parsed) => map[key] = parsed);
    });

    return map;
  }

  /// parse YamList to DartList
  List<dynamic> asList(){
    final List<dynamic> list = [];
    final yamlList = this as YamlList;

    for (var element in yamlList.nodes) {
      _processNode(element, (parsed) => list.add(parsed));
    }

    return list;
  }

  _processNode(dynamic node, ProcessYamlNodeCallback addAction){
    switch(node.runtimeType){
      case YamlMap:
        final nest = (node as YamlMap).asMap();
        addAction.call(nest);
      case YamlList:
        final nest = (node as YamlList).asList();
        addAction.call(nest);
      case YamlScalar:
        final child = node.value;
        addAction.call(child);
      default:
        addAction.call(node);
    }
  }

}
