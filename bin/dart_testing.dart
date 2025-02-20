import 'package:dart_testing/dart_testing.dart' as dart_testing;
import 'package:dart_testing/environment.dart';
import 'package:dart_testing/firebase_service.dart';

Future<void> main(List<String>? arguments) async {
  await Env.load();
  await firebaseService.init();
  await dart_testing.importResourcesFromExcel(
      'resource.xlsx', Env.googleMapsApiKey);
  await firebaseService.close();
}
