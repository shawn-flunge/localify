
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:localify/src/configuration.dart';
import 'package:localify/src/constants.dart';



Future<String> fetchRawDataFromService(Configuration config) async{

  final http.Client client = await switch(config.source){
    DataSource.googleSheets => _googleAuthClient(config),
    DataSource.notionDatabase => _notionAuthClient(config)
  };

  final response = await switch(config.source){
    DataSource.googleSheets => client.get(Uri.parse('$googleSheetsBaseUrl/${config['spread_sheet_id']}/values:batchGet?ranges=${config['sheet_name']}&valueRenderOption=FORMATTED_VALUE')),
    DataSource.notionDatabase => client.post(Uri.parse('$notionDatabaseBaseUrl/${config['database_key']}/query'))
  };

  client.close();
  if(response.statusCode != 200){
    throw 'wrong request or response';
  }

  return response.body;
}

_googleAuthClient(Configuration config) async{
  final jsonString = await File(config['credential_json_path']).readAsString();
  final credentialObject = json.decode(jsonString);
  final scopes = [sheets.SheetsApi.spreadsheetsReadonlyScope];

  final accountCredentials = ServiceAccountCredentials.fromJson({
    "private_key_id": credentialObject['private_key_id'],
    "private_key": credentialObject['private_key'],
    "client_email": credentialObject['client_email'],
    "client_id": credentialObject['client_id'],
    "type": credentialObject['type']
  });

  return clientViaServiceAccount(accountCredentials, scopes);
}

_notionAuthClient(Configuration config) async{
  final Map<String, String> header = {
    'Authorization' : 'Bearer ${config['bearer_token']}',
    'Notion-Version' : '2022-06-28',
    'Content-Type' : 'application/json'
  };

  return _AuthenticatedHttpClient(header);
}



class _AuthenticatedHttpClient extends http.BaseClient {
  final Map<String, String> authHeader;
  final http.Client _inner;

  _AuthenticatedHttpClient(this.authHeader) : _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request);
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return _inner.get(url, headers: authHeader);
  }

  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _inner.post(url, headers: authHeader);
  }
}