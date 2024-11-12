// 기말시험 출제
void main() {
  onPress();
}

Future<int> sum() {
  return Future<int>((){
    var sum = 0;
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    for(int i = 0; i < 500000000; i++) {
      sum += i;
    }
    stopwatch.stop();
    print("${stopwatch.elapsed}, reuslt : $sum");
    return sum;
  });
}

void onPress() {
  print('onPress top...');
  sum();
  print('onPress bottom...');
}