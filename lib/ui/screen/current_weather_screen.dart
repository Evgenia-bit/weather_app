import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/weather_bloc.dart';
import '/ui/element/custom_container.dart';

//второй экран
class CurrentWeatherScreen extends StatelessWidget {
  const CurrentWeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<WeatherBloc>();
    final state = bloc.state;

    //если стейт говорит о том,
    //что идет процесс загрузки,
    //то выводится индикатор загрузки
    if (state is WeatherLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    //если в стейте лежит текущая погода,
    //то выводим блок с информацией о ней (температура, влажность, скорость ветра)
    if (state is CurrentWeatherLoaded) {
      return SizedBox(
        height: 200,
        child: ContentWrapper(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              //Здесь выводится температура
              Text(
                "${state.weather.temp} °C",
                style: const TextStyle(fontSize: 40),
              ),

              //Здесь выводится влажность
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Влажность"),
                  Text("${state.weather.humidity}%"),
                ],
              ),


              //здесь выводится скорость ветра
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Скорость ветра"),
                  Text("${state.weather.windSpeed} м/с"),
                ],
              ),
            ],
          ),
        ),
      );
    }

    //если значение стейта не подходит ни под одну проверку,
    //то просто выводится постой бокс
    return const SizedBox.shrink();
  }
}
