//класс, представляющий собой погоду со всеми данными о ней
class Weather {
  //время измерений
  DateTime date;

  //температура
  num temp;

  //влажность
  int humidity;

  //скорость ветра
  num windSpeed;

  //именованный конструктор, который переводит json в объект Weather
  Weather.fromJson(Map<String, dynamic>? json)
      :
        //дата и время парсятся из секунд и переводится
        // в локальную дату и время с помощью функции getLocateDate
        date = getLocateDate(json?["dt"]),

        //температура округляется до ближайшего целого
        temp = json?["main"]["temp"].round(),

        humidity = json?["main"]["humidity"],

        //скорость ветра округляется до 1 знака после запятой
        windSpeed = json?["wind"]["speed"].roundToDouble();


  //функция, отвечающая за парсинг даты и времени и приведение их к локальным дате и времени
  static DateTime getLocateDate(int date) {
    //миллисекунды переводятся в объект DateTime
    final sourceDate = DateTime.fromMillisecondsSinceEpoch(
      date * 1000,
      isUtc: true,
    );

    //получение текущего DateTime
    final now = DateTime.now();

    //возвращение локализованного DateTime
    return sourceDate.add(now.timeZoneOffset);
  }
}
