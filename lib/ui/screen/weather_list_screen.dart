import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '/bloc/weather_bloc.dart';
import '/models/weather.dart';
import '/ui/element/custom_container.dart';

//третий экран
class WeatherListScreen extends StatelessWidget {
  const WeatherListScreen({Key? key}) : super(key: key);

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

    //если пришел стейт со списком погоды, то выводим этот список
    if (state is WeatherListLoaded) {
      return ContentWrapper(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //шапка списка
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _smallText("Температура"),
                  _smallText("Влажность"),
                  _smallText("Скорость ветра"),
                ],
              ),

              //сам список
              ...state.weatherList
                  .map(
                    (weather) => _WeatherListItem(weather: weather),
                  )
                  .toList(),
            ],
          ),
        ),
      );
    }

    //если значение стейта не подходит ни под одну проверку,
    //то просто выводится постой бокс
    return const SizedBox.shrink();
  }

  //обертка для текста в шапке списка
  Padding _smallText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}

//элемент списка погоды
class _WeatherListItem extends StatelessWidget {
  final Weather weather;

  const _WeatherListItem({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //первый столбец со всеменем и датой
          Row(
            children: [
              Row(
                children: [
                  Text(
                    weather.date.day.toString(),
                    style: const TextStyle(fontSize: 30),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              Column(
                children: [
                  Text(DateFormat("MMMM").format(weather.date)),
                  Text(DateFormat("HH:mm").format(weather.date)),
                ],
              ),
            ],
          ),

          //второй столбец с температурой
          Text("${weather.temp} °C"),

          //третий столбец с влажностью
          Text("${weather.humidity}%"),

          //четвертный столбец со скоростью ветра
          Text("${weather.windSpeed} м/с"),
        ],
      ),
    );
  }
}
