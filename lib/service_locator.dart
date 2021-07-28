import 'package:get_it/get_it.dart';
import 'package:rstrivia/services/highscore_service.dart';
import 'package:rstrivia/services/user_data_service.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<HighscoreService>(() => HighscoreService());
  locator.registerLazySingleton<UserDataService>(() => UserDataService());
}
