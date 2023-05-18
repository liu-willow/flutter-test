
import 'dart:convert';

import 'dart:math';

import 'package:get/get.dart';
import 'package:wallet_test/components/file/file.dart';
import 'package:wallet_test/components/neffos.dart';
import 'package:wallet_test/curl/client/client.dart';

import 'package:wallet_test/data/nft.dart';

import 'package:easy_refresh/easy_refresh.dart';

import 'package:http/http.dart' as http;
import 'package:wallet_test/contracts/HeroGame.g.dart';
import 'package:wallet_test/logger/logger.dart';
import 'package:web3dart/web3dart.dart';

class Home extends GetxController {
  var count = 0.obs;
  increment() => count++;

  final EasyRefreshController refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true,);

  CURL curl = CURL();
  WEB3 web3 = WEB3();
  Neffos neffos = Neffos();

  @override
  void onInit() async {
    super.onInit();
    refreshList();

    // web3.chainId();
    // web3.getLogs();

    neffos.connect();
  }

  int rand(int min, int max) => min + Random().nextInt(max - min);

  List tabs = ["Seascape", "Moonscape", "Miner"].obs;
  late RxList<Nft> nftData = RxList<Nft>();

  var page = 0;
  final int limit = 30;
  void refreshList() async {
    try {
      page = 0;
      nftData.removeRange(0, nftData.length);
      getNftList();
    } catch(e) {
      print(e);
    }
  }
  void getNftList() async {
    try {
      page++;
      nftData.addAll(await curl.nftList(page, limit));
    } catch(e) {
      logger.e(e);
    }
  }
}

class CURL {
  final http.Client client = init('192.168.8.139:1081');
  final String host = 'beta-bsc-api.seascape.network';

  Future<List<Nft>> nftList(int page, int limit) async {
    List<Nft> arr = <Nft>[];

    final url = Uri.https(host, '/nft/nftList/0x5bDed8f6BdAE766C361EDaE25c5DC966BCaF8f43/-1/-1/-1/-1/$page/$limit');
    var response = await client.get(url);
    if (response.statusCode == 200) {
      final resp = Resp.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      arr.addAll(resp.list);
    } else {
      logger.w('Request failed with status: $response');
    }
    return arr;
  }
}

class WEB3 {
  final Web3Client ethClient = Web3Client('https://rpc-mainnet.maticvigil.com/v1/5d1a54daba8bf4cefe3ee508d3cae33168a020b9', init('192.168.8.139:1081'));
  final EthereumAddress contractAddr = EthereumAddress.fromHex('0xeD677D09A345f6894C35342A3753E9cDE20C7136');
  String importNftTopic = "0x39f15e1a3a97a7d9de7944bbd23881496211b5d59ee949f9f3b3b940caffc964";

  void chainId() async {
    BigInt chainId = await ethClient.getChainId();
    loggerNoStack.i(chainId.toInt());
  }

  void getLogs() async {
    final contract = DeployedContract(ContractAbi.fromJson(await file_get_content("json/HeroGame.abi.json"), 'heroGame'), contractAddr);
    final importNftEvent = contract.event('ImportNft');
    ethClient.getLogs(FilterOptions(fromBlock: const BlockNum.exact(42435189), toBlock: const BlockNum.exact(42435609), address: contractAddr, topics: [[importNftTopic]])).then((value) {
      for (var event in value) {
        final decoded = importNftEvent.decodeResults(event.topics!, event.data!);
        ImportNft import = ImportNft(decoded);
        loggerNoStack.v(import.time.toInt());
      }
    });
  }
}