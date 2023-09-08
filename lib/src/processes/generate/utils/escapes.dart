
enum Escapes{
  backSlash([92]),
  newLine([10]),
  hardNewLine([92, 110]),
  doubleQuotes([34]);

  const Escapes(this.codeUnits);

  factory Escapes.fromCodes(List<int> codeUnits) {
    return Escapes.values.singleWhere((element) => element.codeString == codeUnits.toString());
  }

  static RegExp get regExp => RegExp(r'\"|\n|\\n|\\');

  final List<int> codeUnits;
  String get codeString => codeUnits.toString();

  static String replace(String text){
    final value = text.toString().replaceAllMapped(Escapes.regExp, (mapped){
      final target = mapped.input.substring(mapped.start, mapped.end);
      final escape = Escapes.fromCodes(target.codeUnits);

      return switch(escape){
        Escapes.backSlash => '\\\\',
        Escapes.newLine => '\\n',
        Escapes.hardNewLine => target,
        Escapes.doubleQuotes => '\\"'
      };
    });
    return value;
  }
}