part of 'weather_bloc.dart';

abstract class WeatherState {
  const WeatherState();
}

class WeatherInitial extends WeatherState {}

//стейт с текущей погодой
class CurrentWeatherLoaded extends WeatherState {
  final Weather weather;
  CurrentWeatherLoaded(this.weather);
}


//стейт со списком погоды за 3 дня
class WeatherListLoaded extends WeatherState {
 final List<Weather> weatherList;
 WeatherListLoaded(this.weatherList);
}


//стейт, означающий, что сейчас идет загрузка
class WeatherLoading extends WeatherState {}


//стейт с ошибкой, отправляемый во время получения ошибки
class WeatherLoadingFailed extends WeatherState {
  final Object error;
  WeatherLoadingFailed(this.error);
}