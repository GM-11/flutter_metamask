import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class SendTransaction extends StatefulWidget {
  W3MService w3mService;
  String userAddress;

  SendTransaction(
      {super.key, required this.w3mService, required this.userAddress});

  @override
  State<SendTransaction> createState() => _SendTransactionState();
}

class _SendTransactionState extends State<SendTransaction> {
  String message = "";
  late String selectedSenderAdress;

  final List<String> senderAddresses = [
    "0xC2Ccf39a66FE9DF7e1aD9E599f95a78E90e74617",
    "0x9DD04d98143Ae3C2f71507aD70178Ee7c1867C04",
    "0x26f4F8ba2c6152677fBAAcbF3CF6C41F6563c237",
  ];


  @override
  void initState() {
    super.initState();
    selectedSenderAdress = senderAddresses[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Transaction"),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              "Your address: ${widget.userAddress}",
            ),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: message.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(message),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Select sender address",
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedSenderAdress, // Set the initial value
              onChanged: (String? newValue) {
                setState(() {
                  selectedSenderAdress = newValue!;
                });
              },
              items:
                  senderAddresses.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () async {
                  try {
                    widget.w3mService.launchConnectedWallet();
                    final result = await widget.w3mService.web3App!.request(
                      topic: widget.w3mService.session!.topic.toString(),
                      chainId: 'eip155:11155111',
                      request: SessionRequestParams(
                          method: 'eth_sendTransaction',
                          params: [
                            {
                              "from": widget.userAddress,
                              "to":
                                  '0xC2Ccf39a66FE9DF7e1aD9E599f95a78E90e74617',
                              "value": '0x1000000000000'
                            }
                          ]),
                    );

                    setState(() {
                      message = result.toString();
                    });
                  } on JsonRpcError catch (e) {
                    setState(() {
                      message = e.message.toString();
                    });
                  }
                },
                child: const Text("Send transaction"))
          ]),
        ),
      ),
    );
  }
}
