import 'package:envied/envied.dart';
import 'package:gen/src/environment/product_configuration.dart';

part 'env_dev.g.dart';

@Envied(
  path: 'assets/env/.dev.env',
  obfuscate: true,
)

/// Dev environment configuration values
final class DevEnv implements ProductConfiguration {
  @EnviedField(varName: 'BASE_URL')
  static final String _baseUrl = _DevEnv._baseUrl;

  @override
  String get baseUrl => _baseUrl;
}
