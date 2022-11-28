import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _search = TextEditingController();

  List result = [];

  void googleResult(String word) async {
    var url = "https://api.dictionaryapi.dev/api/v2/entries/en/$word";
    var response = await http.get(
      Uri.parse(url),
    );                       

    setState(() {
      result = jsonDecode(response.body);
    });

    print(result);
  }
  @override
  void initState(){
    super.initState();
    googleResult("word");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.1,
        ),
        children: [
          Form(
            key: _formKey,
            child: Container( 
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.08,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                ),
                child: TextFormField(
                  controller: _search,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Input field cannot be blank.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: Text(
                      "Search",
                      style: GoogleFonts.rancho(
                        fontSize: 18,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.teal)
                    ),
                    suffixIcon: GestureDetector(
                      onTap: (){
                        if(_formKey.currentState!.validate()){
                          googleResult(_search.text);
                        }
                      },
                      child: const Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              ...List.generate(result.length, (item) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              result[item]["word"],
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              result[item]["phonetics"][0]["text"].toString(),
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(result[item]["meanings"].length, (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.blue[300],
                          child: Text(
                            (index + 1).toString(),
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.15,
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        decoration: BoxDecoration(
                          color: result[item]["meanings"][0]["partOfSpeech"] == "noun" ? Colors.blue[100] : Colors.tealAccent[100],
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "~ ${result[item]["meanings"][0]["partOfSpeech"]} ~",
                                style: GoogleFonts.rancho(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            ...List.generate(result[item]["meanings"][index]["definitions"].length, (count) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                result[item]["meanings"][index]["definitions"][count]["definition"]
                              ),
                            ))
                          ],
                        ),
                      ),
                    ],
                  )),
                ],
              )),
            ],
          )
        ]
      ),
    );
  }
}