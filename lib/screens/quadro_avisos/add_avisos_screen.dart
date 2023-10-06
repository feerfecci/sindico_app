import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/screens/quadro_avisos/quadro_de_avisos.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/my_text_form_field.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snack.dart';
import '../../consts/const_widget.dart';
import 'package:http/http.dart' as http;

class AddAvisosScreen extends StatefulWidget {
  const AddAvisosScreen({super.key});

  @override
  State<AddAvisosScreen> createState() => _AddAvisosScreenState();
}

class _AddAvisosScreenState extends State<AddAvisosScreen> {
  final _keyForm = GlobalKey<FormState>();
  TextEditingController tituloCntl = TextEditingController();
  TextEditingController textoCntl = TextEditingController();

  bool isFile = false;
  File? fileImage;
  List<String> listImage = [];
  String? nameImage = '';
  String? pathImage = '';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(
      context,
      title: 'Enviar Aviso',
      body: Form(
        key: _keyForm,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Center(child: ConstsWidget.buildCamposObrigatorios(context)),
              buildMyTextFormObrigatorio(context, 'Título',
                  hintText: 'Exemplo: Manutenção do Elevador',
                  textCapitalization: TextCapitalization.words,
                  maxLength: 70,
                  controller: tituloCntl),
              ConstsWidget.buildPadding001(
                context,
                child: buildMyTextFormObrigatorio(context, 'Descrição',
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 8,
                    maxLines: 8,
                    hintText:
                        'Exemplo: Será realizada a manutenção do elevador do bloco C a partir de amanhã (21/06) as 14h.',
                    maxLength: 1000,
                    controller: textoCntl),
              ),
              ConstsWidget.buildOutlinedButton(
                context,
                title: 'Adicionar Arquivo',
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  // if (pickedFile == null) return;

                  if (pickedFile != null) {
                    final file = File(pickedFile.path);
                    nameImage = pickedFile.name;
                    pathImage = pickedFile.path;
                    if (listImage.isEmpty) {
                      setState(() {
                        listImage.add(file.uri.toString());
                      });
                    } else {
                      // ignore: use_build_context_synchronously
                      buildMinhaSnackBar(context,
                          title: 'Cuidado!',
                          hasError: true,
                          subTitle: 'Permitido apenas um arquivo');
                    }
                  }
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              if (listImage != [])
                Padding(
                  padding: EdgeInsets.only(
                    bottom: size.height * 0.02,
                  ),
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listImage.length,
                    itemBuilder: (context, index) {
                      return MyBoxShadow(
                        // width: size.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.upload_file_outlined),
                            Text(
                              // listImage[index],
                              '...${listImage[index].substring(listImage[index].length - 28, listImage[index].length)}',
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  listImage.remove(listImage[index]);
                                  nameImage = '';
                                  pathImage = '';
                                });
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ConstsWidget.buildCustomButton(context, 'Enviar Aviso',
                  color: Consts.kColorRed, onPressed: () {
                var formValid = _keyForm.currentState?.validate();
                FocusManager.instance.primaryFocus!.unfocus();
                if (formValid!) {
                  upload(nameImage: nameImage, pathImage: pathImage)
                      .then((value) {
                    if (!value['erro']) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      FocusManager.instance.primaryFocus?.unfocus();
                      ConstsFuture.navigatorPagePush(context, QuadroDeAvisos());
                      buildMinhaSnackBar(context,
                          title: 'Muito Obrigado!',
                          hasError: value['erro'],
                          subTitle: value['mensagem']);
                    } else {
                      buildMinhaSnackBar(context);
                    }
                  });

                  // ConstsFuture.resquestApi(
                  //         '${Consts.sindicoApi}quadro_avisos/index.php?fn=incluirAviso&idcond=${ResponsalvelInfos.idcondominio}&tipo=1&titulo=${tituloCntl.text}&texto=${textoCntl.text}')
                  //     .then((value) {
                  //   if (!value['erro']) {
                  //     Navigator.pop(context);
                  //     Navigator.pop(context);
                  //     ConstsFuture.navigatorPagePush(
                  //         context, QuadroDeAvisos());
                  //     return buildMinhaSnackBar(context,
                  //         title: 'Muito Obrigado!',
                  //         subTitle: value['mensagem']);
                  //   } else {
                  //     buildMinhaSnackBar(context);
                  //   }
                  // });
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future upload(
      {required String? nameImage, required String? pathImage}) async {
    var postUri = Uri.parse(
        "https://a.portariaapp.com/sindico/api/quadro_avisos/?fn=enviarAviso");

    http.MultipartRequest request = http.MultipartRequest("POST", postUri);

    if (pathImage != '') {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'imagem', pathImage!,
          filename: nameImage);

      request.files.add(multipartFile);
    }
    request.fields['tipo'] = '1';
    request.fields['idcond'] = '${ResponsalvelInfos.idcondominio}';
    request.fields['idfuncionario'] = '${ResponsalvelInfos.idfuncionario}';
    request.fields['titulo'] = tituloCntl.text;
    request.fields['texto'] = textoCntl.text;

    var response = await request.send();

    if (response.statusCode == 200) {
      return {'erro': false, "mensagem": 'Cadastrado com Sucesso!'};
    } else {
      return {'erro': true, 'mensagem': 'Tente Novamente'};
    }
  }
}
