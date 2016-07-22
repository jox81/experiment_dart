import "package:ini/ini.dart";
import 'dart:io';

main() {
  new File(r"C:\Gaming-server\Development\Servers\Server.CircusOnline\bin\Debug\Config.ini").readAsLines()
      .then((lines) => new Config.fromStrings(lines))
      .then((Config config) {
    config.items('SimulSpanishSlotEngine')[0].toString();
  });
}