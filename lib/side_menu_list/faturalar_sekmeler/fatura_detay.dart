import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/alinan_faturala_bloc/alinan_faturalar_bloc.dart';

class FaturaDetayDialog extends StatelessWidget {
  final int? logicalRef;
  final int? tur;

  FaturaDetayDialog({required this.logicalRef, required this.tur});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlinanFaturalarBloc(ApiHandler())
        ..add(LoadFaturaDetay(
          prefix: "",
          suffix: "",
          logicalref: logicalRef,
          tur: tur,
        )),
      child: BlocBuilder<AlinanFaturalarBloc, AlinanFaturalarState>(
        builder: (context, state) {
          if (state is FaturaDetayLoadSuccess) {
            return AlertDialog(
              backgroundColor: Color.fromRGBO(36, 64, 72, 50),
              title: Text(
                'Fatura Detayları',
                style: TextStyle(color: Colors.white),
              ),
              content: state.Faturalar.isEmpty
                  ? Text('Fatura detayları boş.')
                  : Container(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.Faturalar.length,
                        itemBuilder: (context, index) {
                          final fatura = state.Faturalar[index];
                          return ListTile(
                            title: Text(
                              fatura.definitioN ?? "",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${fatura.amount?.toString() ?? 'N/A'} adet * ${fatura.brmfyt} TL + ${fatura.vatamnt} TL',
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                                Text(
                                  'Türü: ${fatura.linetype ?? 'N/A'}',
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Text(
                                  "Toplam",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                                Text(
                                  fatura.nettotal.toString(),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Kapat',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } else if (state is FaturaDetayLoadFailure) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(state.error),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
