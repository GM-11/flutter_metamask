import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class SignMessage extends StatefulWidget {
  W3MService w3mService;
  String userAddress;

  SignMessage({super.key, required this.w3mService, required this.userAddress});

  @override
  State<SignMessage> createState() => _SignMessageState();
}

class _SignMessageState extends State<SignMessage> {
  final _controller = TextEditingController(text: "Message to sign");
  String _resultMessage = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Message"),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final message = _controller.text.trim();
                widget.w3mService.launchConnectedWallet();
                final result = await widget.w3mService.web3App!.request(
                  topic: widget.w3mService.session!.topic.toString(),
                  chainId: 'eip155:11155111',
                  request: SessionRequestParams(
                    method: 'personal_sign',
                    params: [
                      message,
                      widget.userAddress
                    ],
                  ),
                );

                log('this is result: $result');
                // show
                setState(() {
                  _resultMessage = result.toString();
                });
              },
              child: const Text("Sign this message"),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Transaction Hash: $_resultMessage',
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
