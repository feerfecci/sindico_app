import 'dart:io';
import 'package:excel/excel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/screens/quadro_avisos/quadro_de_avisos.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/my_text_form_field.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';
import 'package:validatorless/validatorless.dart';
import '../../consts/const_widget.dart';

class WidgetModalAvisos extends StatefulWidget {
  const WidgetModalAvisos({super.key});

  @override
  State<WidgetModalAvisos> createState() => _WidgetModalAvisosState();
}

class _WidgetModalAvisosState extends State<WidgetModalAvisos> {
  final _keyForm = GlobalKey<FormState>();
  TextEditingController tituloCntl = TextEditingController();
  TextEditingController textoCntl = TextEditingController();
  File? fileImage;
  bool isFile = false;
  List<String> listImage = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Form(
          key: _keyForm,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Row(
                  children: [
                    Spacer(),
                    SizedBox(
                      width: size.width * 0.13,
                    ),
                    ConstsWidget.buildTextTitle(context, 'Aviso Geral',
                        size: 20),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 30,
                        )),
                  ],
                ),
                buildMyTextFormObrigatorio(context, 'Título',
                    hintText: 'Exemplo: ',
                    maxLength: 70,
                    controller: tituloCntl),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: buildMyTextFormObrigatorio(context, 'Descrição',
                      minLines: 8,
                      maxLines: 8,
                      hintText:
                          'Exemplo: Será realizada a manutenção do elevador do bloco C a partir de amanhã (21/06) as 14h. Por favor, utilize as escadarias',
                      maxLength: 1000,
                      controller: textoCntl),
                ),
                ConstsWidget.buildOutlinedButton(
                  context,
                  title: 'Adicionar Arquivo',
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile == null) return;

                    if (!isFile) {
                      final file = File(pickedFile.path);

                      setState(() {
                        listImage.add(file.uri.toString());
                        buildMinhaSnackBar(context,
                            title: 'Esse é apenas um teste',
                            subTitle: 'A imagem não irá para o aviso');
                      });
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
                                '...${listImage[index].substring(listImage[index].length - 28, listImage[index].length)}',
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    listImage.remove(listImage[index]);
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
                  if (formValid!) {
                    // print(listImage.join(','));
                    ConstsFuture.resquestApi(
                            '${Consts.sindicoApi}quadro_avisos/index.php?fn=incluirAviso&idcond=${ResponsalvelInfos.idcondominio}&tipo=1&titulo=${tituloCntl.text}&texto=${textoCntl.text}')
                        .then((value) {
                      if (!value['erro']) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ConstsFuture.navigatorPagePush(
                            context, QuadroDeAvisos());
                        return buildMinhaSnackBar(context,
                            title: 'Muito Obrigado!',
                            subTitle: value['mensagem']);
                      } else {
                        buildMinhaSnackBar(context);
                      }
                    });
                  }
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
