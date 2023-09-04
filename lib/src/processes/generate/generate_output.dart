



import 'package:localify/src/configuration.dart';
import 'package:localify/src/processes/generate/google_sheets/google_sheets.dart';
import 'package:localify/src/processes/generate/utils/fetch_data.dart';

Future<bool> generateOutputFromConfig(Configuration config) async{

  try {

    final rawData = await fetchRawDataFromService(config);

    final bool success = await switch (config.source){
      DataSource.googleSheets => generateOutputsFromGoogleSheetsData(config, rawData),
      DataSource.notionDatabase => throw 'Notion is not supported now'
    };
    /// todo : return "success"
    return success;
  } catch(e){
    print(e);
    return false;
  }
}

