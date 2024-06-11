import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String selcetedName;
  final Function()? onPressed;
const  MyTextBox({ Key? key, required this.text,required this.selcetedName, required this.onPressed }) : super(key: key);


  @override
  Widget build(BuildContext context){
    return Container(
          padding: EdgeInsets.only(left: 20,bottom: 20),
          margin: EdgeInsets.only(left: 15,right: 15,top: 15,),
          decoration: BoxDecoration(
            color:  Colors.grey.shade200,
            borderRadius: BorderRadius.circular(30),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
                children: [
                  Text(selcetedName, style: TextStyle(color: Colors.grey.shade500, fontSize: 15),),
                  IconButton(onPressed: onPressed, icon: Icon(Icons.settings))
                ],
              ),
              Text(text, style: TextStyle(fontSize: 20,color: Colors.blueGrey[600]),)
            ],
          ),
        );
  }
}