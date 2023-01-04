import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final int indexToDelete; //provided by the list view
  final Function deleteFunction;

  DeleteConfirmationDialog({this.indexToDelete, this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,

      content: Text(
        'Voulez-vous supprimer cette note ?',
        style: TextStyle(fontSize: 24),
      ),

      actions: <Widget>[
        FlatButton(

          child: Text('Annuler', style: TextStyle(fontSize: 20,)),

          onPressed: () =>Navigator.pop(context),

        ),

        FlatButton(

          child: Text('Supprimer', style:TextStyle(fontSize: 20)),

          onPressed: () => deleteFunction(indexToDelete),

        )

      ],
    );
  }
}
