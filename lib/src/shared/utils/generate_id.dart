import 'dart:math';

class ID{
  ID();

  String call(){
    String alp = '1234567890';
    String newStr = '';
    for (var i = 0; i<8; i++){
      newStr += alp[Random().nextInt(9)];
    }
    return (DateTime.now().millisecondsSinceEpoch.toString() + newStr);
  }
}