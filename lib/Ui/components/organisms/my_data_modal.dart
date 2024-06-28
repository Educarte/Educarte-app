import 'package:flutter/material.dart';

class MyDataModal extends StatefulWidget {
  const MyDataModal({
    super.key
  });

  @override
  State<MyDataModal> createState() => _MyDataModalState();
}

class _MyDataModalState extends State<MyDataModal> {
  // void meusDados()async{
  //   setLoading(load: true);
  //   var response = await http.get(Uri.parse("http://64.225.53.11:5000/Users/Me"),
  //     headers: {
  //       "Authorization": "Bearer ${globals.token.toString()}",
  //     }
  //   );
  //   if(response.statusCode == 200){
  //     Map<String,dynamic> jsonData = jsonDecode(response.body);

  //     setState(() {
  //       List<String> groupNames = jsonData["name"].toString().split(" ");
  //       globals.nome = groupNames.first;
  //       nome.text = jsonData["name"];
  //       email.text = jsonData["email"];
  //       if(jsonData["cellphone"] != null){
  //         telefone?.text = jsonData["cellphone"];
  //       }
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}