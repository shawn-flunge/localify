



import 'package:localify/src/configuration.dart';
import 'package:localify/src/processes/generate/google_sheets/google_sheets.dart';
import 'package:localify/src/processes/generate/utils/fetch_data.dart';

Future<bool> generateOutputFromConfig(Configuration config) async{

  try {

    final rawData = await fetchRawDataFromService(config);

    final success = switch (config.source){
      DataSource.googleSheets => generateOutputsFromGoogleSheetsData(config, rawData),
      DataSource.notion => print('doesn\'t support yet')
    };
    /// todo : return "success"
    return true;
  } catch(e, s){
    print(e);
    return false;
  }
}

