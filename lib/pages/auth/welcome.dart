import 'package:flutter/material.dart';
class Default extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image(image: AssetImage('assets/images/logo.jpeg'),width: 200,height: 200,),
                Text('Sign Up',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                Text('Connectez-vous simplement',style: TextStyle(fontSize: 18,),),
                
                TextButton(
                  
                  onPressed: (){},
                  style:  TextButton.styleFrom(
  primary: Colors.black87,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:50.0),
                    child: Text(
                      'E-mail',
                      style: TextStyle(color: Colors.grey[500],fontSize: 20),
                    ),
                  ),
                ),
               /*  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('images/ux_ui_01/icons8_Twitter_Circled_48px.png'),
                      width: 35,
                      height: 35,
                    ),
                    Image(
                      image: AssetImage('images/ux_ui_01/google.png'),
                      width: 35,
                      height: 35,
                    ),
                    Image(
                      image: AssetImage('images/ux_ui_01/icons8_LinkedIn_Circled_48px.png'),
                      width: 35,
                      height: 35,
                    ),
                  ],
                ), */
                ElevatedButton(
                  onPressed: (){},
                  child: Text(
                    'Déjà inscrit! Se connecter',
                    style: TextStyle(color: Colors.grey[500],fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}