import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<void> initializeParse() async {
  const keyApplicationId = '<add-application-id-here>';
  const keyClientKey = '<add-client-key-here>';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);
}
