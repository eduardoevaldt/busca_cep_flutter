// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:web_service/formatter/text_input_formatter_cep.dart';
import 'package:web_service/moderate/entities/locality/errors/invalid_cep.dart';

import '../moderate/locality/find_locality_by_cep_output.dart';
import '../moderate/locality/find_locality_by_cep_usecase.dart';
import '../services/buscar_cep.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  FindLocalityByCepOutput? locality;
  TextEditingController cepController = TextEditingController();
  FindLocalityByCepUseCase localityByCepUseCase = BuscarCep.create();

  Future _handlerAsync(Future<String?> Function() callback) async {
    setState(() => loading = true);
    String? feedback = await callback();
    if (feedback != null) {
      SnackBar snackBar = SnackBar(
        content: Text(feedback),
        action: SnackBarAction(
          label: "OK",
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() => loading = false);
  }

  Future _sharedCep() async {
    await _handlerAsync(() async {
      if (locality == null) {
        return "Ainda não há cep para compartilhar!";
      }

      String address =
          "${locality!.city} - ${locality!.state}, ${locality!.cep}";
      if (locality!.street != null) {
        address = "${locality!.street} - ${locality!.neighborhood}, $address";
      }

      await Share.share(address);
      return null;
    });
  }

  Future _searchCep() async {
    await _handlerAsync(() async {
      try {
        final cep = cepController.text;
        FindLocalityByCepOutput locality =
            await localityByCepUseCase.execute(cep);

        setState(() => this.locality = locality);
        return null;
      } catch (error) {
        print(error);
        if (error is InvalidCep) {
          return "Cep Inválido.";
        }
        return "O cep informado não está correto, verifique novamente.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WEB SERVICE CEP"),
        actions: [
          IconButton(
            onPressed: _sharedCep,
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 24, left: 15, right: 15),
              child: Column(
                children: [
                  _buildTextField(),
                  _buildButton(),
                ],
              ),
            ),
            _buildResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      autofocus: true,
      enabled: !loading,
      controller: cepController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      inputFormatters: [TextInputFormatterCep()],
      decoration: const InputDecoration(
        labelText: "Informe o CEP",
        errorText: null,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(38),
      ),
      onPressed: _searchCep,
      child: loading ? _buildLoading() : const Text('BUSCAR'),
    );
  }

  Widget _buildLoading() {
    return const SizedBox(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    );
  }

  Widget _buildResult() {
    if (locality == null) {
      return Column(
        children: const [SizedBox(height: 10)],
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text("Cep"),
              subtitle: Text(locality!.cep),
            ),
            ListTile(
              title: const Text("Cidade"),
              subtitle: Text(locality!.city),
            ),
            ListTile(
              title: const Text("Estado"),
              subtitle: Text(locality!.state),
            ),
            ListTile(
              title: const Text("Bairro"),
              subtitle: Text(locality!.neighborhood ?? "-"),
            ),
            ListTile(
              title: const Text("Rua"),
              subtitle: Text(locality!.street ?? "-"),
            ),
          ],
        ),
      ),
    );
  }
}
