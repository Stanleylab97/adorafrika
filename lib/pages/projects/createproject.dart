import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({super.key});

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final TextEditingController _controllerFullName = new TextEditingController();
  final TextEditingController _controllerEmail = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            Center(
                child: Text(
                    "Remplissez le formulaire pour partager votre projet",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue, fontSize: 21))),
            SizedBox(
              height: 30,
            ),
            TextField(
              // controller: _controllerFullName,
              cursorColor: Colors.deepPurple.shade200,
              style: TextStyle(color: Colors.grey.shade800),

              decoration: InputDecoration(
                hintText: "Titre du projet",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              // controller: _controllerEmail,
              cursorColor: Colors.deepPurple.shade200,
              style: TextStyle(color: Colors.grey.shade800),

              decoration: InputDecoration(
                hintText: "Budget",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: 'Décrivez votre projet ici'),
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              minLines: 1,
              style: TextStyle(color: Colors.grey.shade800),
              // controller: _controllerEmail,
              cursorColor: Colors.deepPurple.shade200,
              //expands: true, // <-- SEE HERE
            ),
            SizedBox(
              height: 10,
            ),
            CachedNetworkImage(
              imageUrl:
                  "https://www.liquidplanner.com/wp-content/uploads/2019/04/HiRes-17.jpg",
              height: MediaQuery.of(context).size.height * .25,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 3,
            ),
            Center(
              child: FloatingActionButton.extended(
                label: Text('Image de couverture'), // <-- Text
                backgroundColor: Colors.black,
                icon: Icon(
                  // <-- Icon
                  Icons.upload_rounded,
                  size: 24.0,
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(
                        "Document du projet:  ",
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "monprojet.pdf",
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => CreateProject()));
                  },
                  child: Icon(Icons.upload_file_rounded),
                  backgroundColor: Colors.blue,
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  //createNewUser();
                  Navigator.pop(context);
                },
                child: Text(
                  "Soumettre le projet",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
