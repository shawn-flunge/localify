

import 'package:localify/localify.dart';
import 'package:localify/src/processes/generate/generate_output.dart';

import 'commands/generate.dart';

void main(List<String> arguments) async{
  final commandRunner = CommandRunner<Configuration>(programName, 'description')
    ..addCommand(GenerateCommand());

  try{
    final result = await commandRunner.run(arguments);

    if(result == null) return;

    final bool success = await generateOutputFromConfig(result);
    if(success){
      print('Your work is successfully done!');
    } else{
      print('Something went wrong.');
    }
  } catch(e){
    print(e);
  }
}
