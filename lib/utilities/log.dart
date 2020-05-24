void printT(String msg) {
  print((new DateTime.now()).toIso8601String() + ' : ' + msg);
}

void printE(String msg) {
  print('[ERROR] - ' + (new DateTime.now()).toIso8601String() + ' : ' + msg);
}
