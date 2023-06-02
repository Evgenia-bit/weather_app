import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/weather_bloc.dart';


//кнопка для перехода на экран со списком погоды за 3 дня
class WeatherListButton extends StatelessWidget {
  const WeatherListButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        //при нажатии на кнопуку инициируемся событие загрузки списка погоды
        context.read<WeatherBloc>().add(LoadWeatherList());

        //далее происходит переход на 3 экран
        Navigator.of(context).pushNamed("weatherListScreen");
      },
      child: const Text("Показать за 3 дня"),
    );
  }
}
