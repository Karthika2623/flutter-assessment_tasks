import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/network/api_client.dart';
import 'features/countries/data/country_repository.dart';
import 'features/countries/presentation/country_controller.dart';
import 'features/users/data/user_repository.dart';
import 'features/users/presentation/user_controller.dart';
import 'features/home/presentation/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ApiClient(), permanent: true);
  Get.put(CountryRepository(Get.find<ApiClient>()), permanent: true);
  Get.put(UserRepository(Get.find<ApiClient>()), permanent: true);
  Get.put(CountryController(Get.find<CountryRepository>()), permanent: true);
  Get.put(UserController(Get.find<UserRepository>()), permanent: true);
  runApp(const ExplorerApp());
}

class ExplorerApp extends StatelessWidget {
  const ExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF6C4DFF);
    return GetMaterialApp(
      title: 'Assessment Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F1FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F1FF),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFEFF),
          hintStyle: const TextStyle(color: Color(0xFF9188AB)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE3DDF7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: seed, width: 1.5),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFEFF),
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE1D9FF)),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
