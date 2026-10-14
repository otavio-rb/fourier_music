import 'package:get_it/get_it.dart';
import '../controller/auth_controller.dart';
import '../controller/explore_controller.dart';
import '../controller/library_controller.dart';
import '../controller/player_controller.dart';

final GetIt getIt = GetIt.instance;

void configurarDependencias() {
  getIt.registerSingleton<AuthController>(AuthController());
  getIt.registerSingleton<PlayerController>(PlayerController());
  getIt.registerSingleton<LibraryController>(LibraryController());
  getIt.registerSingleton<ExploreController>(ExploreController());
}
