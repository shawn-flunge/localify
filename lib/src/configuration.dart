
enum DataSource{
  googleSheets('google_sheets', ['spread_sheet_id', 'sheet_name', 'credential_json_path']),
  notion('notion', ['']);

  final String name;
  final List<String> needs;

  const DataSource(this.name, this.needs);
}

enum OutputExtension{
  json('json'),
  arb('arb');

  final String _str;
  const OutputExtension(this._str);

  static OutputExtension fromJson(String value){
    if(value == 'json') {
      return OutputExtension.json;
    } else {
      return OutputExtension.arb;
    }
  }

  @override
  String toString() => _str;
}

class Configuration {

  final Map<String, dynamic> _origin;
  final String outputDir;
  final OutputExtension outputExtension;
  late final bool isCompact;
  final DataSource source;

  Configuration._internal(this._origin,{
    this.outputDir = './assets/i18n',
    this.outputExtension = OutputExtension.arb,
    required this.source,
  });

  factory Configuration.fromYaml(Map<String, dynamic> yaml) {

    return Configuration._internal(
        yaml,
        outputDir: yaml['output_dir'],
        outputExtension: OutputExtension.fromJson(yaml['output_extension']),
        source: _createSourceFromYaml(yaml)
    );
  }

  /// todo : 서비스별 toString
  @override
  String toString() => 'Configuration(outputDir: $outputDir, outputExtension: $outputExtension, source: $source, isCompact: $isCompact)';

  dynamic operator [](String key) => _origin[source.name][key];
}


_createSourceFromYaml(Map<String, dynamic> yaml){

  final sources = DataSource.values.where((element) => yaml[element.name] != null );
  if(sources.length != 1) throw 'it needs only one data source';
  return sources.first;
}
