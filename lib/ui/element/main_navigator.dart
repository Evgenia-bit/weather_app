import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/weather_bloc.dart';
import '/ui/screen/city_entry_screen.dart';
import '/ui/screen/current_weather_screen.dart';
import '/ui/element/get_weather_list_button.dart';
import '/ui/screen/weather_list_screen.dart';

//навигатор, который отвечает за перемещения по трем страницам
class MainNavigator extends StatelessWidget {
  const MainNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: "cityEntryScreen",
      onGenerateRoute: (settings) {
        final bloc = context.read<WeatherBloc>();

        //если произошел пуш на страницу с текущей погодой,
        //то возвращается соответствующий виджет
        if (settings.name == "currentWeatherScreen") {
          return _route(
            screen: const CurrentWeatherScreen(),
            //кнопка в actions является кнопкой перехода на 3 экран
            actions: [const WeatherListButton()],
            title: bloc.cityName,
          );
        }

        //если произошел пуш на страницу со спиской погоды,
        //то возвращается соответствующий виджет
        if (settings.name == "weatherListScreen") {
          return _route(
            screen: const WeatherListScreen(),
            //функция back позволяет загрузить текущую
            //погоду при переходе с третьего на второй экран
            back: () => bloc.add(LoadCurrentWeather()),
            title: bloc.cityName,
          );
        }

        //если пользователь только зашел в приложение,
        //то ему возвращается сообветствующий виджет с формой для ввод города
        return _route(isMain: true, screen: CityEntryScreen(), title: "Погода");
      },
    );
  }

  //функция _route нужна для обертки виджетов экранов,
  //которые пушатся через навигатор
  MaterialPageRoute _route({
    //параметр isMain нужен для определения того,
    //является ли данный экран главным.
    //Если экран главный, то кнопка Назад не выводится
    bool isMain = false,

    //параметр screen - это сам виджет экрана
    required Widget screen,

    //параметр title - заголовок экрана.
    //Выводится в шапке
    required String title,

    //actions - массив с кнопками, которые помещаются в шапку.
    //В этом приложении нужен только для вывода кнопки перехода на 3 экран
    List<Widget>? actions,

    //Функция, которая отпрабатывает при нажатии на кнопку Назад,
    //помимо перехода на предыдущую страницу.
    //В данном случае она нужна,
    //чтобы при переходе с третьего на второй экран загрузить текущую погоду
    void Function()? back,
  }) {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            leading: isMain
                ? null
                : BackButton(
                    onPressed: () {
                      //действия, которые происходят при нажатии на кнопку назад
                      if (back != null) back();
                      Navigator.of(context).pop();
                    },
                  ),
            actions: actions,
          ),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: screen,
          ),
        );
      },
    );
  }
}
