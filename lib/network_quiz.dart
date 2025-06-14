import 'dart:math';

// Convert IP string to 32-bit integer
int ipToInt(String ip) =>
    ip.split('.').fold(0, (acc, octet) => (acc << 8) | int.parse(octet));

// Convert 32-bit integer to IP string
String intToIp(int ip) => [
  (ip >> 24) & 0xFF,
  (ip >> 16) & 0xFF,
  (ip >> 8) & 0xFF,
  ip & 0xFF,
].join('.');

// Convert subnet mask to prefix length
int maskToPrefixLength(String mask) {
  final maskInt = ipToInt(mask);
  int count = 0;
  int temp = maskInt;
  while (temp != 0) {
    if ((temp & 1) == 1) count++;
    temp >>= 1;
  }
  return count;
}

// Convert prefix length to subnet mask
String prefixLengthToMask(int prefixLength) {
  final mask = prefixLength == 0 ? 0 : (0xFFFFFFFF << (32 - prefixLength));
  return intToIp(mask);
}

// Get network address
String getNetworkId(String ip, int prefixLength) {
  final ipInt = ipToInt(ip);
  final mask = prefixLength == 0 ? 0 : (0xFFFFFFFF << (32 - prefixLength));
  return intToIp(ipInt & mask);
}

// Get broadcast address
String getBroadcastAddress(String ip, int prefixLength) {
  final ipInt = ipToInt(ip);
  final mask = prefixLength == 0 ? 0 : (0xFFFFFFFF << (32 - prefixLength));
  return intToIp(ipInt | (~mask & 0xFFFFFFFF));
}

// Check if two IPs are in the same network segment
bool areInSameNetwork(String ip1, String ip2, int prefixLength) {
  final network1 = getNetworkId(ip1, prefixLength);
  final network2 = getNetworkId(ip2, prefixLength);
  return network1 == network2;
}

class NetworkQuestion {
  String question;
  String correctAnswer;
  List<String> options;
  String type;

  NetworkQuestion(this.question, this.correctAnswer, this.options, this.type);
}

class NetworkQuizGenerator {
  List<NetworkQuestion> generateQuestionsForLevel(int level) {
    switch (level) {
      case 1:
        return generateLevel1Questions();
      case 2:
        return generateLevel2Questions();
      case 3:
        return generateLevel3Questions();
      default:
        return generateLevel1Questions();
    }
  }

  final Random random = Random();

  // Level 1: Basic /8, /16, /24 networks
  List<NetworkQuestion> generateLevel1Questions() {
    List<NetworkQuestion> questions = [];
    List<int> basicMasks = [8, 16, 24];

    // Question 1: Network ID
    String ip1 = _generateRandomIP();
    int mask1 = basicMasks[random.nextInt(basicMasks.length)];
    String networkId = getNetworkId(ip1, mask1);
    questions.add(
      NetworkQuestion(
        "Qual é o Network ID do endereço IP $ip1 com máscara /$mask1?",
        networkId,
        _generateNetworkIdOptions(ip1, mask1, networkId),
        "Network ID",
      ),
    );

    // Question 2: Broadcast
    String ip2 = _generateRandomIP();
    int mask2 = basicMasks[random.nextInt(basicMasks.length)];
    String broadcast = getBroadcastAddress(ip2, mask2);
    questions.add(
      NetworkQuestion(
        "Qual é o Broadcast do endereço IP $ip2 com máscara /$mask2?",
        broadcast,
        _generateBroadcastOptions(ip2, mask2, broadcast),
        "Broadcast",
      ),
    );

    // Question 3: Same network
    var ips = _generateSmartRandomIPs(
      basicMasks[random.nextInt(basicMasks.length)],
    );
    String ip3a = ips[0], ip3b = ips[1];
    int mask3 = ips[2];
    bool sameNetwork = areInSameNetwork(ip3a, ip3b, mask3);
    questions.add(
      NetworkQuestion(
        "Os endereços $ip3a e $ip3b estão na mesma rede com máscara /$mask3?",
        sameNetwork ? "Sim" : "Não",
        ["Sim", "Não"],
        "Mesma Rede",
      ),
    );

    return questions;
  }

  // Level 2: Subnets with decimal masks
  List<NetworkQuestion> generateLevel2Questions() {
    List<NetworkQuestion> questions = [];
    List<Map<String, dynamic>> subnetMasks = [
      {'mask': '255.255.255.192', 'prefix': 26},
      {'mask': '255.255.255.224', 'prefix': 27},
      {'mask': '255.255.255.240', 'prefix': 28},
      {'mask': '255.255.255.248', 'prefix': 29},
      {'mask': '255.255.255.252', 'prefix': 30},
    ];

    var maskInfo = subnetMasks[random.nextInt(subnetMasks.length)];
    int prefix = maskInfo['prefix'];
    String mask = maskInfo['mask'];

    // Question 1: Network ID with decimal mask
    String ip1 = _generateRandomIP();
    String networkId = getNetworkId(ip1, prefix);
    questions.add(
      NetworkQuestion(
        "Qual é o Network ID do IP $ip1 com máscara $mask?",
        networkId,
        _generateNetworkIdOptions(ip1, prefix, networkId),
        "Network ID",
      ),
    );

    // Question 2: Broadcast with decimal mask
    String ip2 = _generateRandomIP();
    String broadcast = getBroadcastAddress(ip2, prefix);
    questions.add(
      NetworkQuestion(
        "Qual é o Broadcast do IP $ip2 com máscara $mask?",
        broadcast,
        _generateBroadcastOptions(ip2, prefix, broadcast),
        "Broadcast",
      ),
    );

    // Question 3: Same network with decimal mask
    var ips = _generateSmartRandomIPs(prefix);
    String ip3a = ips[0], ip3b = ips[1];
    bool sameNetwork = areInSameNetwork(ip3a, ip3b, prefix);
    questions.add(
      NetworkQuestion(
        "Os IPs $ip3a e $ip3b estão na mesma rede com máscara $mask?",
        sameNetwork ? "Sim" : "Não",
        ["Sim", "Não"],
        "Mesma Rede",
      ),
    );

    return questions;
  }

  // Level 3: Supernets
  List<NetworkQuestion> generateLevel3Questions() {
    List<NetworkQuestion> questions = [];
    List<Map<String, dynamic>> supernetMasks = [
      {'mask': '255.255.252.0', 'prefix': 22},
      {'mask': '255.255.248.0', 'prefix': 21},
      {'mask': '255.255.240.0', 'prefix': 20},
      {'mask': '255.255.224.0', 'prefix': 19},
      {'mask': '255.255.192.0', 'prefix': 18},
    ];

    var maskInfo = supernetMasks[random.nextInt(supernetMasks.length)];
    int prefix = maskInfo['prefix'];
    String mask = maskInfo['mask'];

    // Question 1: Network ID with supernet mask
    String ip1 = _generateRandomIP();
    String networkId = getNetworkId(ip1, prefix);
    questions.add(
      NetworkQuestion(
        "Qual é o Network ID do IP $ip1 com máscara $mask?",
        networkId,
        _generateNetworkIdOptions(ip1, prefix, networkId, isSupernet: true),
        "Network ID",
      ),
    );

    // Question 2: Broadcast with supernet mask
    String ip2 = _generateRandomIP();
    String broadcast = getBroadcastAddress(ip2, prefix);
    questions.add(
      NetworkQuestion(
        "Qual é o Broadcast do IP $ip2 com máscara $mask?",
        broadcast,
        _generateBroadcastOptions(ip2, prefix, broadcast, isSupernet: true),
        "Broadcast",
      ),
    );

    // Question 3: Same network with supernet mask
    var ips = _generateSmartRandomIPs(prefix);
    String ip3a = ips[0], ip3b = ips[1];
    bool sameNetwork = areInSameNetwork(ip3a, ip3b, prefix);
    questions.add(
      NetworkQuestion(
        "Os IPs $ip3a e $ip3b estão na mesma super-rede com máscara $mask?",
        sameNetwork ? "Sim" : "Não",
        ["Sim", "Não", "Apenas se for classe B", "Somente com roteamento"],
        "Same Network",
      ),
    );

    return questions;
  }

  // Helper methods to generate options
  List<String> _generateNetworkIdOptions(
    String ip,
    int prefix,
    String correctAnswer, {
    bool isSupernet = false,
  }) {
    List<String> options = [correctAnswer];
    String baseNetwork = correctAnswer.substring(
      0,
      correctAnswer.lastIndexOf('.'),
    );

    // Generate wrong options
    options.add(getNetworkId(_generateRandomIP(), prefix));
    options.add("$baseNetwork.1");
    options.add(_modifyLastOctet(correctAnswer, random.nextInt(254) + 1));

    if (isSupernet) {
      options.add(getNetworkId(ip, prefix - 1));
    }

    options.shuffle();
    return options.take(4).toList();
  }

  List<String> _generateBroadcastOptions(
    String ip,
    int prefix,
    String correctAnswer, {
    bool isSupernet = false,
  }) {
    List<String> options = [correctAnswer];
    String baseNetwork = correctAnswer.substring(
      0,
      correctAnswer.lastIndexOf('.'),
    );

    // Generate wrong options
    options.add(
      getBroadcastAddress(_generateRandomIP(), prefix),
    ); // Random IP same mask
    options.add("$baseNetwork.0"); // Common wrong answer (network ID)
    options.add(_modifyLastOctet(correctAnswer, -1)); // Previous address

    if (isSupernet) {
      options.add(getBroadcastAddress(ip, prefix - 1)); // Larger broadcast
    }

    options.shuffle();
    return options.take(4).toList();
  }

  String _modifyLastOctet(String ip, int change) {
    List<String> parts = ip.split('.');
    int lastOctet = int.parse(parts[3]) + change;
    lastOctet = lastOctet.clamp(0, 255);
    parts[3] = lastOctet.toString();
    return parts.join('.');
  }

  // Keep existing helper methods (_generateRandomIP, _generateSmartRandomIPs)
  String _generateRandomIP() {
    return [
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    ].join('.');
  }

  List<dynamic> _generateSmartRandomIPs(int prefixLength) {
    final shouldBeSameNetwork = random.nextBool();

    if (shouldBeSameNetwork) {
      final baseIP = _generateRandomIP();
      final baseInt = ipToInt(baseIP);
      final mask = prefixLength == 0 ? 0 : (0xFFFFFFFF << (32 - prefixLength));
      final networkPart = baseInt & mask;
      final hostBits = 32 - prefixLength;
      final maxHostValue = hostBits >= 32 ? 0xFFFFFFFF : ((1 << hostBits) - 1);
      final host1 = random.nextInt(maxHostValue + 1);
      final host2 = random.nextInt(maxHostValue + 1);
      return [
        intToIp(networkPart | host1),
        intToIp(networkPart | host2),
        prefixLength,
      ];
    } else {
      return [_generateRandomIP(), _generateRandomIP(), prefixLength];
    }
  }
}
