import 'package:adorafrika/models/project.dart';
import 'package:adorafrika/pages/projects/createproject.dart';
import 'package:adorafrika/pages/projects/projectdetails.dart';
import 'package:adorafrika/pages/projects/widgets/myprojects_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Myprojects extends StatefulWidget {
  const Myprojects({super.key});

  @override
  State<Myprojects> createState() => _MyprojectsState();
}

class _MyprojectsState extends State<Myprojects> {
  List<Project> myprojects = [
    Project(
        title: "Concert à Canal Olympia",
        type: "Musique",
        photoUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLZ1hsJEdGlHix0DUkUX6nUzwd0MM4Xh4WnrwJdI0ewjagplL2Y85GYC-9VDx8sgx0IP0&usqp=CAU",
        author_firstname: "Mario",
        author_surname: "Lopez",
        description: "here are many variations of passages",
        file_link: "https://www.africau.edu/images/default/sample.pdf",
        createdAt: "17-10-2022"),
    Project(
        title: "Doumentaire des WACHI",
        type: "Culture",
        photoUrl:
            "http://zayglam.fr/wp-content/uploads/2021/01/culture-africaine-scaled.jpg",
        author_firstname: "Mario",
        author_surname: "Lopez",
        description: "here are many variations of passages",
        file_link: "https://www.africau.edu/images/default/sample.pdf",
        createdAt: "17-10-2022"),
    Project(
        title: "Concert de KIDJO",
        type: "Musique",
        photoUrl:
            "https://www.un.org/africarenewal/sites/www.un.org.africarenewal/files/kejo.jpg",
        author_firstname: "Mario",
        author_surname: "Lopez",
        description: "There are many variations of passages",
        file_link: "https://www.africau.edu/images/default/sample.pdf",
        createdAt: "17-10-2022"),
    Project(
        title: "Dotation de fournitures",
        type: "Education",
        photoUrl:
            "https://barafiki.org/wp-content/uploads/2021/07/Campagne-Rentree-scolaire-solidaire_Mini-1024x1024.png",
        author_firstname: "Mario",
        author_surname: "Lopez",
        description: "There are many variations of passages",
        file_link: "https://www.africau.edu/images/default/sample.pdf",
        createdAt: "17-10-2022"),
    Project(
        title: "Promotion des langues du Mali",
        type: "Langue",
        photoUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLZ1hsJEdGlHix0DUkUX6nUzwd0MM4Xh4WnrwJdI0ewjagplL2Y85GYC-9VDx8sgx0IP0&usqp=CAU",
        author_firstname: "Mario",
        author_surname: "Lopez",
        description: "There are many variations of passages",
        file_link: "https://www.africau.edu/images/default/sample.pdf",
        createdAt: "17-10-2022")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: InkWell(
                  child: MyProjectWidget(myprojects[index]),
                  onTap: (() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProjectDetails()));
                  }),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "projet",
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateProject()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple.shade300,
      ),
    );
  }
}
