import 'package:flutter/material.dart';

class TournamentDialog extends StatefulWidget{

  @override State createState() => _TournamentDialogState();
}

class _TournamentDialogState extends State{
  int _winner = 0;

  @override Widget build(BuildContext context){
    return Container();
    // Widget _resultAlertDialog(BuildContext _context, List _player){
    //   String _winner = _player[0];
    //   return AlertDialog(
    //     title: Text('Risultato'),
    //     content: SingleChildScrollView(
    //       child: ListBody(
    //         children: <Widget>[
    //           Radio(
    //             value: _player[0],
    //             groupValue: _winner,
    //             onChanged: (value) {
    //               print(value);
    //               setState(() {
    //                 _winner = value;
    //               });
    //             }
    //           ),//end Radio
    //           Radio(
    //             value: _player[1],
    //             groupValue: _winner,
    //             onChanged: (value) {
    //               print(value);
    //               setState(() {
    //                 _winner = value;
    //               });
    //             }
    //           ),//end Radio
    //         ],
    //       ),//end ListBody
    //     ),//end SingleChildScrollView
    //     actions: <Widget>[
    //       FlatButton(
    //         child: Text('Avanti'),
    //         onPressed: ()=>print('save it!'),
    //       ), //end FlatButton
    //       FlatButton(
    //         child: Text('Chiudi'),
    //         onPressed: ()=>Navigator.of(_context).pop(),
    //       ), //end FlatButton
    //     ]
    //   );
    // }
  }
}
