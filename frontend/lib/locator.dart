
import 'package:flutter_front_end/repositories/chat_repository.dart';
import 'package:flutter_front_end/services/audio_services.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton(AudioPlayerService.getInstance());
  locator.registerFactory(() => ChatRepository());
}