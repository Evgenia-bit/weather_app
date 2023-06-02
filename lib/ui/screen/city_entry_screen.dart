import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/weather_bloc.dart';


//первый экран приложения
class CityEntryScreen extends StatelessWidget {
  CityEntryScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Введите название города"),

          //поле для ввода города
          TextFormField(

            //здесь описана валидация формы,
            //которая заключается в проверке поля на пустоту
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },

            //вызывается после нажатия на пноку "Потвердить",
            //если поле прошло валидацию (не пустое)
            onSaved: (value) async {
              final bloc = context.read<WeatherBloc>();

              //в WeatherBloc присваивается значение имени города,
              //которое становится единым для всего приложения
              bloc.cityName = value!;

              //инициируется событие загрузки текущей погоды
              bloc.add(LoadCurrentWeather());

             //в цикле перебираются стейты, которые возвращает WeatherBloc
              await for (WeatherState state in bloc.stream) {

                //если стейт представляет собой ошибку,
                //то определяется сообщение об ошибке на основе типа ошибки,
                //которое выводится в SnackBar в середине экрана.
                //Далее в этом же условии происходит выход из цикла,
                //чтобы не переходить к обрабокте следующего стейта
                if (state is WeatherLoadingFailed) {
                  final error = state.error;
                  String errorMessage;

                  //определение сообщения об ошибке
                  if (error is SocketException) {
                    errorMessage = "Ошибка подключения к Интернету";
                  } else if (error is Exception) {
                    errorMessage = error.toString().substring(11);
                  } else {
                    errorMessage = "Произошла неизвестная ошибка";
                  }

                  //вывод сообщения в SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height / 3,
                      ),
                      content: SizedBox(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Ошибка получения данных",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(errorMessage),
                          ],
                        ),
                      ),
                    ),
                  );

                  //выход из цикла
                  break;
                }

                //Если стейт представляет собой текущую погоду,
                //то есть она была получена и не произошло никаких ошибок,
                //то происходит переход на второй экран и выход из цикла
                else if (state is CurrentWeatherLoaded) {
                  Navigator.of(context).pushNamed("currentWeatherScreen");
                  break;
                }
              }
            },
          ),
         const SizedBox(height: 20),

          //кнопка подтвеорждения города
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              //если кнопка была нажата, то происходит валидация формы
              //и ее сохранение в случае успешной валидации
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
              }
            },
            child: Text(
              "Подтвердить",
              style: TextStyle(color: Theme.of(context).canvasColor),
            ),
          ),
        ],
      ),
    );
  }
}
