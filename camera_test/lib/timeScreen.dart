import 'dart:async';

import 'package:camera_test/timer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late TimerBloc _timerBloc;
  TextEditingController _otpController = TextEditingController();
  late StreamController<ErrorAnimationType> _errorController;

  @override
  void initState() {
    super.initState();
    _timerBloc = TimerBloc();
    _startTimer();
    _errorController = StreamController<ErrorAnimationType>();
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      _timerBloc.add(1);
    });
  }

  @override
  void dispose() {
    _timerBloc.close();
    _otpController.dispose();
    _errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('One Minute Countdown Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<TimerBloc, int>(
              bloc: _timerBloc,
              builder: (context, state) {
                return Text(
                  '$state seconds',
                  style: TextStyle(fontSize: 24),
                );
              },
            ),
            SizedBox(height: 20),
            buildOtpField(),
          ],
        ),
      ),
    );
  }

  Widget buildOtpField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: 400,
        child: PinCodeTextField(
          appContext: context,
          length: 5,
          controller: _otpController,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            selectedFillColor: Colors.transparent,
            selectedColor: Colors.blue,
            activeColor: Colors.black,
            inactiveColor: Colors.grey,
          ),
          animationType: AnimationType.slide,
          animationDuration: Duration(milliseconds: 300),
          errorAnimationController: _errorController,
          onCompleted: (otp) {
            // Handle the OTP completion logic here
            print("Completed OTP: $otp");
          },
          onChanged: (otp) {
            // Handle the OTP changed logic here (if needed)
          },
        ),
      ),
    );
  }
}
