import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_for_friflex/bloc/weather_bloc.dart';

import 'package:test_for_friflex/ui/element/main_navigator.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //определение темной и светлой тем
      theme: theme(),
      darkTheme: theme(true),

      //BlocProvider поставляет WeatherBloc всему приложению,
      //чтобы из любого виджета можно было получить доступ к объекту WeatherBloc
      home: BlocProvider(
        create: (BuildContext context) {
          return WeatherBloc();
        },
        child: const MainNavigator(),
      ),
    );
  }


  //функция для генерации ThemeData для светлой и темной тем
  ThemeData theme([bool dark = false]) {
    final scheme = dark ? const ColorScheme.dark() : const ColorScheme.light();
    return ThemeData(
      colorScheme: scheme,
      primaryColor: scheme.primary,
      useMaterial3: true,
    );
  }
}
