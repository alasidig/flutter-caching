import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

import 'add_name_form_widget.dart';
import 'text_with_bg_widget.dart';
@Entity()
class Person {
  @Id()
  int id;
  String name;

  Person({
    this.id = 0,
    required this.name,
  });
  @Backlink()
  final pets = ToMany<Pet>();
}
@Entity()
class Pet {
  @Id()
  int id;
  String name;
  Pet({
    this.id = 0,
    required this.name,
  });
  final owner = ToOne<Person>();
}

class HomePageObjectBox extends StatefulWidget {
  const HomePageObjectBox({super.key, required this.store});
  final Store store;

  @override
  State<HomePageObjectBox> createState() => _HomePageObjectBoxState();
}

class _HomePageObjectBoxState extends State<HomePageObjectBox> {
  late Box<Person> personBox;
  late  Box<Pet> petBox ;
  List<Person> persons = [];

  @override
  void initState() {
    super.initState();
    personBox = widget.store.box<Person>();
    petBox = widget.store.box<Pet>();
    getPersons();
  }

  void getPersons() {
    setState(() {
      persons = personBox.getAll();
    });
  }

  addPerson(String fullName) {
    Person person = Person(name: fullName);
    personBox.put(person);
    getPersons();
  }
  addPet(Person person, String petName) {
    Pet pet = Pet(name: petName);
    pet.owner.target = person;
    petBox.put(pet);
    getPersons();
  }
  deletePet(Pet pet) {
    petBox.remove(pet.id);
    getPersons();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistence'),
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        AddNameForm(label: 'Person Name', onSubmit: addPerson),
        const SizedBox(height: 20),
        const TextBoxWithBackground(
            text: 'Table of Persons', backgroundColor: Colors.green),
        //create a data table to show the list of persons
        DataTable(
          columnSpacing: 1,
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('#Pets')),
            DataColumn(label: Text('+ Pet')),
          ],
          rows: persons
              .map((person) => DataRow(cells: [
                    DataCell(Text(person.id.toString())),
                    DataCell(Text(person.name)),
                    DataCell(Text(person.pets.length.toString()), onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: TextBoxWithBackground(
                                  text: '${person.name} Pets',
                                  backgroundColor: Colors.blue,
                                ),
                                actions: [IconButton(onPressed: () {
                                  Navigator.of(context).pop();
                                }, icon: const Icon(Icons.close)) ],
                                content: SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: PersonPetsList(
                                      pets: person.pets,
                                      onDelete: (pet) {
                                        deletePet(pet);
                                      }),
                                ));
                          });
                    }),
                    DataCell(IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                  title: const Text('Add a Pet'),
                                  children: [
                                    AddNameForm(
                                      label: 'Pet Name',
                                      onSubmit: (petName) {
                                        addPet(person, petName);
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ]);
                            });
                      },
                      icon: const Icon(Icons.pets_rounded),
                    )),
                  ]))
              .toList(),
        )
      ]),
    );
  }
}

class PersonPetsList extends StatelessWidget {
  const PersonPetsList({super.key, required this.pets, required this.onDelete});

  final List<Pet> pets;
  final void Function(Pet) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(pets[index].name),
              trailing: IconButton(
                onPressed: () {
                  onDelete(pets[index]);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.delete),
              ));
        });
  }
}



