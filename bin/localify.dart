

import 'package:localify/localify.dart';

void main(List<String> arguments) async{
  final commandRunner = CommandRunner<Configuration>(programName, 'description')
    ..addCommand(GenerateCommand());

  try{
    final result = await commandRunner.run(arguments);

    if(result == null) return;

    // final bool success = await switch (result){
    //   GenerateConfiguration() => generateOutputFromConfig(result)
    // // BuildConfiguration() => print(result)
    // };

  } catch(e){
    print(e);
  }
}
