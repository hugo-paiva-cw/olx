import 'package:flutter/material.dart';

import '../../models/add.dart';

class ItemAdd extends StatelessWidget {
  Add add;
  VoidCallback? onTapItem;
  VoidCallback? onPressedRemove;

  ItemAdd({
  required this.add,
  this.onTapItem,
    this.onPressedRemove,
  Key? key
}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapItem,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row( children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image.network(
                  add.photos[0],
                  fit: BoxFit.cover,
                ),
              ),

            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                        add.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(add.price),
                  ],),
                )
            ),

            if ( onPressedRemove != null ) Expanded(
                flex: 1,
                child: FlatButton(
                  color: Colors.red,
                  padding: const EdgeInsets.all(10),
                  onPressed: onPressedRemove,
                  child: const Icon(Icons.delete, color: Colors.white,),
                )
              )

            ],
          ),
        ),
      ),
    );
  }
}
