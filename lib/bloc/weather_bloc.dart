import 'package:bloc/bloc.dart';
import '/api_data_provider.dart';
import '/models/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final apiDataProvider = ApiDataProvider();

  //Название города одно для всего приложения. Оно присваивается при нажатии кнопки "Подтвердить" на первом экране
  String cityName = "";

  WeatherBloc() : super(WeatherInitial()) {
    //обработка события, происходящего при нажатии на кнопку получения погоды за 3 дня
    on<LoadWeatherList>(_handleLoadWeatherList);

    //обработка события, происходящего при нажатии на кнопку "Подтвердить" после ввода города
    on<LoadCurrentWeather>(_handleLoadCurrentWeather);
  }

  _handleLoadWeatherList(event, emit) async {
    try {
      //включение индикатора загрузки
      emit(WeatherLoading());

      //получение списка погоды за 3 дня
      final weatherList = await apiDataProvider.getWeatherList(cityName);

      //сортировка по температуре от меньшего к большему
      weatherList.sort((a, b) => a.temp.compareTo(b.temp));

      //отправка на ui списка погоды в стейте
      emit(WeatherListLoaded(weatherList));
    } catch (e) {
      //в случае появления ошибки/исключения при получении данных эта ошибка/исключение ловится и отправляется на ui в стейте
      emit(WeatherLoadingFailed(e));
    }
  }

  _handleLoadCurrentWeather(event, emit) async {
    try {
      //включение индикатора загрузки
      emit(WeatherLoading());

      //получение стекущей погоды
      final currentWeather = await apiDataProvider.getCurrentWeather(cityName);

      //отправка на ui текущей погоды в стейте
      emit(CurrentWeatherLoaded(currentWeather));
    } catch (e) {
      //в случае появления ошибки/исключения при получении данных эта ошибка/исключение ловится и отправляется на ui в стейте
      emit(WeatherLoadingFailed(e));
    }
  }
}
