import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(AlarmApp());
}

class AlarmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AlarmScreen(),
    );
  }
}

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  bool _alarmActive = false;
  int _pin = 0;
  String _enteredPin = '';
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _generateRandomPin();
  }

  void _generateRandomPin() {
    final _random = Random();
    setState(() {
      _pin = _random.nextInt(8999) + 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Будильник'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _alarmActive
                ? Text(
              'Время просыпаться!',
              style: TextStyle(fontSize: 24),
            )
                : Text(
              'Будильник выключен',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            _alarmActive
                ? TextField(
              onChanged: (value) {
                setState(() {
                  _enteredPin = value;
                });
              },
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Введите пин-код',
              ),
            )
                : SizedBox(),
            SizedBox(height: 20),
            _alarmActive
                ? ElevatedButton(
              onPressed: () {
                if (_enteredPin == _pin.toString()) {
                  _stopAlarm();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Неверный пин-код'),
                  ));
                }
              },
              child: Text('Выключить будильник'),
            )
                : ElevatedButton(
              onPressed: () {
                _selectTime(context);
              },
              child: Text('Включить будильник'),
            ),
            SizedBox(height: 10),
            Text(
              'Пин-код: $_pin',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _startAlarm();
      });
    }
  }

  void _startAlarm() {
    setState(() {
      _alarmActive = true;
      _generateRandomPin();
    });
  }

  void _stopAlarm() {
    setState(() {
      _alarmActive = false;
      _enteredPin = '';
    });
  }
}
