


import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:localify/src/commands/utils/config_from_yaml.dart';
import 'package:localify/src/configuration.dart';

class GenerateCommand extends Command<Configuration>{

  @override
  String get name => 'generate';

  @override
  String get description => 'Generate outputs for i18n';

  @override
  final ArgParser argParser = ArgParser()..addFlag('compact', abbr: 'c');

  @override
  FutureOr<Configuration> run() async{
    final configuration = await parseConfigurationFromYaml('localify.yaml', argResults?.wasParsed('compact') ?? false);
    return configuration;
  }
}