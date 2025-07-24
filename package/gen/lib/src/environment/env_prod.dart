import 'package:envied/envied.dart';
import 'package:gen/src/environment/product_configuration.dart';

part 'env_prod.g.dart';

@Envied(
  path: 'assets/env/.prod.env',
  obfuscate: true,
)

/// [ProdEnv] is a class that implements [ProductConfiguration] interface
final class ProdEnv implements ProductConfiguration {
  @EnviedField(varName: 'BASE_URL')
  static final String _baseUrl = _ProdEnv._baseUrl;

  @override
  String get baseUrl => _baseUrl;
}
