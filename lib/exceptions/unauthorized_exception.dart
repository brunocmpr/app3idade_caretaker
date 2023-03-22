class UnauthorizedException implements Exception {
  final String? msg;
  const UnauthorizedException([this.msg]);
  @override
  String toString() => msg ?? "Operação não autorizada pelo servidor.";
}
