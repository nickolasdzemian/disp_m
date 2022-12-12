String dumpHexToString(List<int> data) {
  StringBuffer sb = StringBuffer();
  for (var f in data) {
    sb.write(f.toRadixString(16).padLeft(2, '0'));
    sb.write(" ");
  }
  return sb.toString();
}
