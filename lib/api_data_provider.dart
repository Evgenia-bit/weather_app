import 'dart:convert';
import 'package:http/http.dart';

import '/config.dart';
import '/models/weather.dart';

//класс, отвечающий за получение данных о погоде
class ApiDataProvider {
  //метод получения текущей погоды
  Future<Weather> getCurrentWeather(String cityName) async {
    //отправление запроса на api с укавзанным городом и appid из класса конфига
    final result = await get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&APPID=${Config.appID}",
      ),
    );

    //декодирования ответа в json
    final json = jsonDecode(processResponse(result));

    //созвращение объекта Weather, сериализованного из json
    return Weather.fromJson(json);
  }

  //метод получения списка погоды
  Future<List<Weather>> getWeatherList(String cityName) async {
    //получение количества часов до конца третьего дня (начиная с текущего).
    //Это время, на которое нужно изнать погоду
    final hourlyLimit = 72 - DateTime.now().hour;

    //вычисление на основе количества часов лимита результата запроса
    //(поскольку погода приходит за время с разницей в 3 часа)
    final resultLimit = (hourlyLimit / 3).floor();

    //отправка запроса на api для получения погоды
    final result = await get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&cnt=$resultLimit&units=metric&APPID=${Config.appID}",
      ),
    );

    //декодирование ответа в json
    final json = jsonDecode(processResponse(result));

    //возвращение списка с объектами Weather, сериализованными из json
    return json?["list"]
        .map<Weather>(
          (weather) => Weather.fromJson(weather),
        )
        .toList();
  }

  //метод обработки ответов на запросы на основе статус кодов.
  //Если все хорошо, то возвращается тело ответа,
  //иначе выбрасывается исключение с сообщением об ошибке
  String processResponse(Response response) {
    //если все прошло успешно, то возвращается тело ответо,
    //которое в последствии декодируется в json
    if (response.statusCode == 200) {
      return response.body;
    }

    //если вернулся статус 404, значит город не найден
    else if (response.statusCode == 404) {
      throw Exception("Город не найден");
    }

    //если вернулся статус 401, значит неверный appID,
    //то есть произошла ошибка авторизации
    else if (response.statusCode == 401) {
      throw Exception("Произошла ошибка авторизации");
    }

    //если вернулся статус 500, значит произошла ошибка сервера
    else if (response.statusCode == 500) {
      throw Exception("Произошла ошибка сервера");
    }

    //если не выполнено ни одно условие,
    //то выбрасывается исключение с сообщением о том,
    //что что-то пошло не так
    throw Exception("Что-то пошло не так");
  }
}
