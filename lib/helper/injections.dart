import 'package:get_it/get_it.dart';
import 'dio_client.dart';

final GetIt getIt = GetIt.instance;

void initializeSingletons() {
  getIt.registerSingleton<DioClient>(DioClient());
}
