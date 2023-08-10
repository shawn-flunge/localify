

import 'package:localify/localify.dart';
import 'package:localify/src/processes/generate/generate_output.dart';

void main(List<String> arguments) async{
  final commandRunner = CommandRunner<Configuration>(programName, 'description')
    ..addCommand(GenerateCommand());

  try{
    final result = await commandRunner.run(arguments);

    if(result == null) return;

    final bool success = await generateOutputFromConfig(result);

  } catch(e){
    print(e);
  }
}
