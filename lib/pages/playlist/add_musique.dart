import 'dart:ui';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class AddMusic extends StatefulWidget {

   const AddMusic({Key? key}): super(key: key);

  @override
  State<AddMusic> createState() => _AddMusicState();
}

class _AddMusicState extends State<AddMusic> {
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  
  late SingleValueDropDownController _cnt;
  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            title: Text('Identification'),
            content: Column(
              children: [
                /* DropDownTextField( */
                /*   initialValue: "Saisissez le secteur", */
                /*   clearOption: false, */

                /*   textFieldFocusNode: textFieldFocusNode, */
                /*   searchFocusNode: searchFocusNode, */
                /*   searchDecoration: */
                /*       const InputDecoration(hintText: "Saisissez le secteur"), */
                /*   // searchAutofocus: true, */
                /*   dropDownItemCount: 8, */
                /*   searchShowCursor: false, */
                /*   enableSearch: true, */
                /*   searchKeyboardType: TextInputType.text, */
                /*   dropDownList: const [ */
                /*     DropDownValueModel(name: 'name1', value: "value1"), */
                /*     DropDownValueModel( */
                /*         name: 'name2', */
                /*         value: "value2", */
                /*         toolTipMsg: */
                /*             "DropDownButton is a widget that we can use to select one unique value from a set of values"), */
                /*     DropDownValueModel(name: 'name3', value: "value3"), */
                /*     DropDownValueModel( */
                /*         name: 'name4', */
                /*         value: "value4", */
                /*         toolTipMsg: */
                /*             "DropDownButton is a widget that we can use to select one unique value from a set of values"), */
                /*     DropDownValueModel(name: 'name5', value: "value5"), */
                /*     DropDownValueModel(name: 'name6', value: "value6"), */
                /*     DropDownValueModel(name: 'name7', value: "value7"), */
                /*     DropDownValueModel(name: 'name8', value: "value8"), */
                /*   ], */
                /*   onChanged: (val) {}, */
                /* ), */
                /* DropDownTextField( */
                /*   clearOption: false, */
                /*   textFieldFocusNode: textFieldFocusNode, */
                /*   searchFocusNode: searchFocusNode, */
                /*   searchDecoration: const InputDecoration( */
                /*       hintText: "Saisissez la sous-catégorie"), */
                /*   // searchAutofocus: true, */
                /*   dropDownItemCount: 8, */
                /*   searchShowCursor: false, */
                /*   enableSearch: true, */
                /*   searchKeyboardType: TextInputType.number, */
                /*   dropDownList: const [ */
                /*     DropDownValueModel(name: 'name1', value: "value1"), */
                /*     DropDownValueModel( */
                /*         name: 'name2', */
                /*         value: "value2", */
                /*         toolTipMsg: */
                /*             "DropDownButton is a widget that we can use to select one unique value from a set of values"), */
                /*     DropDownValueModel(name: 'name3', value: "value3"), */
                /*     DropDownValueModel( */
                /*         name: 'name4', */
                /*         value: "value4", */
                /*         toolTipMsg: */
                /*             "DropDownButton is a widget that we can use to select one unique value from a set of values"), */
                /*     DropDownValueModel(name: 'name5', value: "value5"), */
                /*     DropDownValueModel(name: 'name6', value: "value6"), */
                /*     DropDownValueModel(name: 'name7', value: "value7"), */
                /*     DropDownValueModel(name: 'name8', value: "value8"), */
                /*   ], */
                /*   onChanged: (val) {}, */
                /* ), */
                TextFormField(
                   controller: titreCtrl,
                  decoration: InputDecoration(labelText: 'Titre'),
                ),
                TextFormField(
   controller: titreCtrl,
  decoration: InputDecoration(labelText: 'Titre'),
)
              ],
            ),
            isActive: currentStep >= 0),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            title: Text('Tarif'),
            content: Column(children: [
              Center(
                  child: Text("Tarif estimatif",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w600))),
              SizedBox(
                height: 30,
              ),
              Row(children: [
                Text(
                  "Réservation: ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Électricien - Électricien auto",
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.w600))
              ]),
              SizedBox(
                height: 20,
              ),
              Row(children: [
                Text("Coût :",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600)),
                SizedBox(
                  width: 50,
                ),
                Text("5.000 F",
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.w600))
              ])
            ]),
            isActive: currentStep >= 1),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            title: Text('Complément'),
            content: Column(children: [
              TextFormField(
                // controller: qteController,
                decoration: InputDecoration(labelText: 'Lieu d\'intervention'),
              ),
              TextFormField(
                maxLines: 5,
                // controller: qteController,
                decoration:
                    InputDecoration(labelText: 'Informations suplémentaires'),
              )
            ]),
            isActive: currentStep >= 2),
        Step(
            state: currentStep > 3 ? StepState.complete : StepState.indexed,
            title: Text('Paiement'),
            content: Column(children: [
              Row(
                children: [
                  Text("Finalisez votre réservation avec notre partenaire "),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.height * .1,
              ),
              Image.asset(
                'assets/images/fedapay-removebg-preview.png',
                height: MediaQuery.of(context).size.height * .2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              Center(
                child: FloatingActionButton.extended(
                  label: Text(
                    'Payer maintenant',
                    style: TextStyle(color: Colors.white),
                  ), // <-- Text
                  backgroundColor: Colors.blue,
                  icon: Icon(
                    Icons.money,
                    size: 24.0,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
            ]),
            isActive: currentStep >= 3),
      ];
  int currentStep = 0;
  bool isCompleted = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
        child: Material(
      child: Theme(
        data: Theme.of(context)
            .copyWith(colorScheme: ColorScheme.light(primary: Colors.orange)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 55),
              child: Center(
                child: Text("Chargement de musique",
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            Stepper(
              steps: getSteps(),
              type: StepperType.vertical,
              currentStep: currentStep,
              onStepTapped: (step) => setState(() {
                currentStep = step;
              }),
              onStepContinue: () {
                final isLastStep = currentStep == getSteps().length - 1;
                if (isLastStep) {
                  setState(() {
                    isCompleted = true;
                  });

                  CherryToast.success(
                          title: Text("Succès"),
                          displayTitle: false,
                          description:
                              Text("Votre musique vient de se charger avec succès!"),
                          animationType: AnimationType.fromRight,
                          animationDuration: Duration(milliseconds: 800),
                          autoDismiss: true)
                      .show(context);
                  //Navigator.pop(context);
                } else {
                  setState(() {
                    currentStep += 1;
                  });
                }
              },
              onStepCancel: () {
                if (currentStep == 0) {
                  null;
                } else {
                  setState(() {
                    currentStep -= 1;
                  });
                }
              },
              controlsBuilder: (context, ControlsDetails controls) {
                final isLastStep = currentStep == getSteps().length - 1;

                return Container(
                    margin: EdgeInsets.only(
                      top: 50,
                    ),
                    child: Row(children: [
                      if (currentStep != 0)
                        Expanded(
                            child: ElevatedButton(
                                child: Text("Précédant"),
                                onPressed: controls.onStepCancel)),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              child: Text(isLastStep ? "Terminer" : "Suivant"),
                              onPressed: controls.onStepContinue)),
                    ]));
              },
            ),
            Container(height: 600,)
          ],
        ),
      ),
    ));
  }
}
