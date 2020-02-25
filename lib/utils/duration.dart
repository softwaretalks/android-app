import 'zero.dart';

String getDurationOfSecond(int duration) {

  var duration1 = Duration(seconds: duration);
  return "${putZero(duration1.inHours)}:${putZero(duration1.inMinutes.remainder(60))}:${putZero(duration1.inSeconds.remainder(60))}";


}

