import 'package:adorafrika/pages/projects/myprojects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  int currentIndex = 0;

  List<String> categoriesProjet = [
    "Mes projets",
    "Culturels",
    "Langues",
    "Éducation",
  ];

  List<Widget> tabChildren = [
    Myprojects(),
    Scaffold(

    ),
    Placeholder(),
    Placeholder(),
  ];

  _smoothScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(microseconds: 100),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController =
        TabController(length: categoriesProjet.length, vsync: this);
    _tabController.addListener(_smoothScrollToTop);
    super.initState();
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return /* Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(bottom:10.0, left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Explorez les projets des talents d'Afrique",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: size.height * .03), */
        NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 50, 25, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "AdorAfrika",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Times",
                          fontSize: 22,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(left: 25),
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                        labelPadding: EdgeInsets.only(right: 15),
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: _tabController,
                        isScrollable: true,
                        indicator: UnderlineTabIndicator(),
                        labelColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                            fontFamily: "Avenir",
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                        unselectedLabelColor: Colors.black45,
                        unselectedLabelStyle: TextStyle(
                            fontFamily: "Avenir",
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                        tabs: List.generate(categoriesProjet.length,
                            (index) => Text(categoriesProjet[index]))),
                  ),
                ),
              ];
            },
            body: Container(
              child: TabBarView(
                  controller: _tabController,
                  children: List.generate(tabChildren.length, (index) {
                    return tabChildren[index];
                  })),
            ));

    /*   )),
      
    ); */
  }
}
