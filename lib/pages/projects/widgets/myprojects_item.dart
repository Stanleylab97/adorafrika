import 'package:flutter/material.dart';
import 'package:adorafrika/models/project.dart';


Widget MyProjectWidget(Project project){
return Card(
elevation:2,
margin: EdgeInsets.only(bottom: 20.0),
child: Padding(
  padding:EdgeInsets.all(8.0),
  child:Row(
    children:[
      Container(
        width: 120,
      height:120,
      decoration: BoxDecoration(
        image: DecorationImage(
         image: NetworkImage(project.photoUrl),
         fit: BoxFit.cover
        ),
        borderRadius:BorderRadius.circular(8.0),

      )),
      SizedBox(width: 5),
      Expanded(child:
        Row(children:[
Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(project.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, color:Colors.black)),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                Icon(Icons.person),
                Text(project.author_surname,style: TextStyle(fontSize: 12, color:Colors.grey.shade700)),
                SizedBox(width: 3),
                
                Text(project.author_firstname,style: TextStyle(fontSize: 12, color:Colors.grey.shade700)),
                                SizedBox(width: 20),

                Text(project.createdAt,style: TextStyle(fontSize: 12, color:Colors.grey.shade700)),
              ]),
              Row(children:[
                             Text("Type : ", style:TextStyle(fontSize: 12, color:Colors.grey.shade700)),
                              SizedBox(width: 5),
                              Text(project.type, style: TextStyle(fontSize: 12, color:Colors.black))

              ]),
              Text(project.description,
              maxLines:3,
              style: TextStyle(fontSize: 12,color:Colors.grey.shade700)),
           

          ]
        ),
        Center(child: Icon(Icons.arrow_right, size:30))
        ]))
        
      
    ]
  )

)
);

}