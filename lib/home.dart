import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_metamask/send_transaction.dart';
import 'package:flutter_metamask/sign_message.dart';
import 'package:web3modal_flutter/services/explorer_service/models/api_response.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late W3MService _w3mService;
  late W3MWalletInfo _w3mWalletInfo;
  late W3MChainInfo _w3mChainInfo;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    _w3mService = W3MService(
      projectId: 'bb280692c8f5b9a86cec5c6916b0cf19',
      metadata: const PairingMetadata(
        name: 'Metamask connect Flutter',
        description: 'Web3Modal Flutter Example',
        url: 'https://cloud.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );

    _w3mWalletInfo = W3MWalletInfo(
        listing: Listing(
            id: "c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96",
            name: "MetaMask",
            homepage: "https://metamask.io/",
            imageId: "5195e9db-94d8-4579-6f11-ef553be95100",
            order: 10,
            mobileLink: "metamask://",
            appStore: "https://apps.apple.com/us/app/metamask/id1438144202",
            playStore: "https://play.google.com/store/apps/details?id=io.metamask",
            rdns: "io.metamask",
            injected: [
              Injected(namespace: "eip155", injectedId: "isMetaMask")
            ]),
        installed: true,
        recent: true);

    _w3mChainInfo = W3MChainInfo(
      chainName: "Sepolia",
      chainId: "11155111",
      namespace: "eip155:11155111",
      tokenName: "ETH",
      rpcUrl: "https://sepolia.infura.io/v3/d66891f4698b4fe68397ad9394ad66d3",
      blockExplorer: W3MBlockExplorer(
          name: "Sepolia Scan", url: "https://sepolia.etherscan.io/"),
    );

    await _w3mService.init();

    // _w3mService.
    _w3mService.addListener(_serviceListener);
    _w3mService.onSessionEventEvent.subscribe(_onSessionEvent);
    _w3mService.onSessionUpdateEvent.subscribe(_onSessionUpdate);
    _w3mService.onSessionConnectEvent.subscribe(_onSessionConnect);
    _w3mService.onSessionDeleteEvent.subscribe(_onSessionDelete);
  }

  void _serviceListener() {
    setState(() {});
  }

  void _onSessionEvent(SessionEvent? args) {
    debugPrint('[$runtimeType] _onSessionEvent $args');
  }

  void _onSessionUpdate(SessionUpdate? args) {
    debugPrint('[$runtimeType] _onSessionUpdate $args');
  }

  void _onSessionConnect(SessionConnect? args) {
    debugPrint('[$runtimeType] _onSessionConnect $args');
  }

  void _onSessionDelete(SessionDelete? args) {
    debugPrint('[$runtimeType] _onSessionDelete $args');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metamask connect Flutter'),
      ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            if (_w3mService.isConnected && _w3mService.session != null)
              SizedBox(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Connected address: ${(_w3mService.session as dynamic).address.toString()}",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.5),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => SendTransaction(
                                    w3mService: _w3mService,
                                    userAddress:
                                        (_w3mService.session as dynamic)
                                            .address
                                            .toString(),
                                  )),
                            ),
                          );
                        },
                        child: const Text("Send Transaction")),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => SignMessage(
                                  w3mService: _w3mService,
                                  userAddress:
                                      _w3mService.session!.address.toString(),
                                )),
                          ),
                        );
                      },
                      child: const Text("Sign Message"),
                    ),
                  ],
                ),
              ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_w3mService.isConnected) {
                    _w3mService.disconnect();
                  } else {
                    _w3mService.selectChain(
                      _w3mChainInfo,
                    );
                    _w3mService.selectWallet(_w3mWalletInfo);
                    log(_w3mService.selectedChain!.toString());
                    // _w3mService.
                    _w3mService.connectSelectedWallet();
                    // _w3mService.openModal(context);
                  }
                } catch (e) {
                  log(e.toString());
                }
              },
              child: Text(!_w3mService.isConnected ? "Connect" : "Disconnect"),
            ),
          ],
        ),
      ),
    );
  }
}
