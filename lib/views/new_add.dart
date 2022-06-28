import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/bloc/item_bloc.dart';
import 'package:olx/models/add.dart';
import 'package:olx/views/widgets/button_customized.dart';
import 'package:olx/views/widgets/input_customized.dart';
import 'dart:io';

import 'package:validadores/Validador.dart';

import '../bloc/item_event.dart';
import '../bloc/item_state.dart';
import '../util/configurations.dart';

class NewAdd extends StatefulWidget {
  const NewAdd({Key? key}) : super(key: key);

  @override
  State<NewAdd> createState() => _NewAddState();
}

class _NewAddState extends State<NewAdd> {
  // Using Bloc
  late final ItemBloc bloc;


  final List<File> _imagesList = [];
  late List<DropdownMenuItem<String>> _listItemsDropEstados = [];
  late List<DropdownMenuItem<String>> _listItemsDropCategories = [];
  final _formKey = GlobalKey<FormState>();
  // TextEditingController controller = TextEditingController();
  Add? _add;
  late BuildContext _dialogContext;

  final ImagePicker _picker = ImagePicker();

  _selectImageFromGallery() async {
    XFile? selectedImage;
    selectedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (selectedImage == null) return;

    File image = File(selectedImage.path);
    setState(() {
      _imagesList.add(image);
    });
  }

  _openDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text('Salvando anúncio')
              ],
            ),
          );
        });
  }

  _saveAdd() async {
    _openDialog(_dialogContext);

    await _uploadImages();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String idLoggedUser = user!.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('my_adds')
        .doc(idLoggedUser)
        .collection('adds')
        .doc(_add!.id)
        .set(_add!.toMap())
        .then((_) {

          // saving public add
      db.collection('adds')
          .doc(_add!.id)
          .set( _add!.toMap() ).then( (_) {
            Navigator.pop(_dialogContext);

            Navigator.pop(context);
      });
    });
  }

  Future _uploadImages() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference rootFolder = storage.ref();

    for (var image in _imagesList) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference file =
          rootFolder.child('my_adds').child(_add!.id).child(imageName);

      UploadTask uploadTask = file.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      var url = await taskSnapshot.ref.getDownloadURL();
      _add!.photos.add(url);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadItemsDropdown();

    _add = Add.generateId();

    // Using bloc
    bloc = ItemBloc();
    bloc.add(LoadItemEvent());
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  _loadItemsDropdown() {

    _listItemsDropCategories = Configurations.getCategories();

    _listItemsDropEstados = Configurations.getEstados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo anúncio'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField<List>(
                  initialValue: _imagesList,
                  validator: (images) {
                    if (images!.isEmpty) {
                      return 'Necessário selecinar uma imagem!';
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(children: [
                      Container(
                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _imagesList.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _imagesList.length) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      _selectImageFromGallery();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade400,
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: Colors.grey.shade100,
                                          ),
                                          Text(
                                            'Adicionar',
                                            style: TextStyle(
                                                color: Colors.grey.shade100),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (_imagesList.isNotEmpty) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.file(
                                                        _imagesList[index]),
                                                    FlatButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _imagesList
                                                                .removeAt(
                                                                    index);
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Excluir'))
                                                  ],
                                                ),
                                              ));
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          FileImage(_imagesList[index]),
                                      child: Container(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.4),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return Container();
                            }),
                      ),
                      state.hasError
                          ? Container(
                              child: Text(
                              '[${state.errorText}]',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                            ))
                          : Container()
                    ]);
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: DropdownButtonFormField<String>(
                            hint: const Text('Estados'),
                            onSaved: (estado) {
                              _add?.estado = estado!;
                            },
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                            items: _listItemsDropEstados,
                            validator: (value) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(value);
                            },
                            onChanged: (value) {},
                          )),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: StreamBuilder<ItemState>(
                            stream: bloc.stream,
                              builder: (context, AsyncSnapshot<ItemState> snapshot){

                                final itemListDropEstados = snapshot.data?.items ?? [];

                                List<DropdownMenuItem<String>> itemsDropCategories = [];

                                itemsDropCategories.add(const DropdownMenuItem(
                                  value: null,
                                  child: Text(
                                    'Categoria',
                                    style: TextStyle(color: Color(0xff9c27b0)),
                                  ),
                                ));

                                itemListDropEstados.forEach((item) {
                                  itemsDropCategories.add(DropdownMenuItem(
                                    value: item.valor,
                                    child: Text(item.nome),
                                  ));
                                });

                                return DropdownButtonFormField<String>(
                                  hint: const Text('Categoria'),
                                  onSaved: (categorie) {
                                    _add?.categorie = categorie!;
                                  },
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20),
                                  items: itemsDropCategories,
                                  validator: (value) {
                                    return Validador()
                                        .add(Validar.OBRIGATORIO,
                                        msg: 'Campo obrigatório')
                                        .valido(value);
                                  },
                                  onChanged: (value) {},
                                );
                              }
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomized(
                    hint: 'Título',
                    onSaved: (title) {
                      _add?.title = title!;
                    },
                    validator: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(value);
                    },
                    // controller: controller,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomized(
                    hint: 'Preço',
                    onSaved: (price) {
                      _add?.price = price!;
                    },
                    type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true)
                    ],
                    validator: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(value);
                    },
                    // controller: controller,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomized(
                    hint: 'Telefone',
                    onSaved: (phone) {
                      _add?.phone = phone!;
                    },
                    type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    validator: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(value);
                    },
                    // controller: controller,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomized(
                    hint: 'Descrição (200 caracteres)',
                    onSaved: (description) {
                      _add?.description = description!;
                    },
                    maxLines: null,
                    validator: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .maxLength(200, msg: 'Máximo de 200 caracteres')
                          .valido(value);
                    },
                  ),
                ),
                ButtonCustomized(
                  text: "Cadastrar anúncio",
                  onPressed: () {
                    if (_formKey.currentState == null) {
                      return;
                    }

                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();

                      // set the dialog context
                      _dialogContext = context;

                      _saveAdd();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
