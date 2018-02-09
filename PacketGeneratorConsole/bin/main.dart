import '../lib/packet_generator_lib.dart';
import 'package:args/args.dart';

main(List<String> arguments) async {
  var parser = new ArgParser();
  parser.addOption("packetFile", abbr: "p");
  parser.addOption("outDir", abbr: "o");

  try {
    var results = parser.parse(arguments);
    final packetFile = results["packetFile"];
    final outDir = results["outDir"];
    if ((packetFile == null) || (outDir == null))
      throw new Exception("Wrong usage");

    final packetGenerator = new PacketGenerator(packetFile, outDir);
    await packetGenerator.generate();
  } on GeneratorException catch (e) {
    print(e.message);
  } catch (e) {
    print("Usage: pacgen -p=<packet file name> -o=<output directory>");
    print("");
    print(parser.usage);
  }
}
