part of 'weather_bloc.dart';


abstract class WeatherEvent {
  const WeatherEvent();
}

//Событие, происходящее при переходе на второй экран для получения текущей погоды
class LoadCurrentWeather extends WeatherEvent {}

//Событие, происходящее при переходе на третий экран для получения списка погоды за 3 дня
class LoadWeatherList extends WeatherEvent {}
