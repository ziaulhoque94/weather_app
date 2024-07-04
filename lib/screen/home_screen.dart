import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _wf.currentWeatherByCityName("Nangolkot").then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        title: Text("Weater",
        style: TextStyle(
          fontSize: 21, color: Colors.white, fontWeight: FontWeight.w500
        ),),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    if (_weather == null) {
      return Center(
        child: const CircularProgressIndicator(
          color: Colors.green,
        ),
      );
    }

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city header
            _LocationHeader(),
            SizedBox(
              height: height * 0.05,
            ),
      
            // Data and time information section
            _dateTimeInfo(),
      
            SizedBox(
              height: height * 0.02,
            ),
      
            _weatherIcon(),
            SizedBox(
              height: height * 0.02,
            ),
      
            _currentTemp(),
      
            SizedBox(
              height: height * 0.02,
            ),
      
            _extraInfo(context),
      
            SizedBox(
              height: height * 0.02,
            ),
      
            _searchHeader(searchController, context),
            // _extraInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _LocationHeader() {
    return Text("City: ${
        _weather?.areaName ?? ""}",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: TextStyle(fontSize: 35),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              "  ${DateFormat("d.m.y").format(now)}",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        )
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "http://openweathermap.org/img/wn/${_weather!.weatherIcon}@4x.png")),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(color: Colors.black, fontSize: 20),
        )
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w500, fontSize: 50),
    );
  }

  Widget _extraInfo(context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Container(
      height: height * 0.12,
      width: width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)} %",
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _searchHeader(TextEditingController controller, context) {
    var width = MediaQuery.sizeOf(context).width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width * 0.80,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width * 0.45,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      labelText: 'search city',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black))),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: width * 0.30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        elevation: 10,
                        shadowColor: Colors.white),
                    onPressed: () {
                      _wf
                          .currentWeatherByCityName(controller.text.toString())
                          .then((w) {
                        setState(() {
                          _weather = w;
                        });
                      });
                    },
                    child: Text(
                      "Search",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    )),
              )
            ],
          ),
        )
      ],
    );
  }
}
