




import 'package:args/command_runner.dart';
import 'package:localify/src/commands/generate.dart';
import 'package:localify/src/configuration.dart';
import 'package:localify/src/constants.dart';
import 'package:test/test.dart';



/// you must make "localify.yaml" before running test
void main(){

  late final CommandRunner commandRunner;

  setUp(() => commandRunner = CommandRunner<Configuration>(programName, 'description')
    ..addCommand(GenerateCommand())
  );

  test('"generate" command test', () async{

    final result = await commandRunner.run(['generate' ,'-c']);

    expect(result.runtimeType, Configuration);
    result as Configuration;
    expect(result.isCompact, true);
  });


}