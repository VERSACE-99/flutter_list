void main() {
  induk();
  print('endProcess');
}

Future induk() async {
  var version = await lookupVersion();
  print(version);
}

int lookupVersion(){
  return 100;
}