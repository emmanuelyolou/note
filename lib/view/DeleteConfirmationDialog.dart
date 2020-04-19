import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final int indexToDelete;
  final Function deleteFunction;

  DeleteConfirmationDialog({this.indexToDelete, this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
              content: Text(
                'Voulez-vous supprimer cette note ?',
                style:TextStyle(fontSize: 24),
              ),

              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Annuler',
                    style: TextStyle(fontSize: 20,),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),

                FlatButton(
                  child: Text(
                    'Supprimer',
                    style:TextStyle(fontSize: 20),),
                  onPressed: () => deleteFunction(indexToDelete),
                )

              ],
            );
  }
}