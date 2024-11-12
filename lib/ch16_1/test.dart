void main() {
  onPress();
}

void sum() {
  var sum = 0;
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for(int i = 0; i <= 5000000000; i++) {
    sum += i;
  }
  stopwatch.stop();
  print("${stopwatch.elapsed}, result : $sum");
}

void onPress() {
  print('onPress top...');
  sum();
  print('onPress bottom...');
}