import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hook_up_rent/models/community.dart';
import 'package:hook_up_rent/models/general_type.dart';
import 'package:hook_up_rent/scoped_model/auth.dart';
import 'package:hook_up_rent/utils/common_toast.dart';
import 'package:hook_up_rent/utils/dio_http.dart';
import 'package:hook_up_rent/utils/scopoed_model_helper.dart';
import 'package:hook_up_rent/utils/string_is_null_or_empty.dart';
import 'package:hook_up_rent/utils/upload_images.dart';
import 'package:hook_up_rent/widgets/common_floating_action_button.dart';
import 'package:hook_up_rent/widgets/common_form_item.dart';
import 'package:hook_up_rent/widgets/common_image_picker.dart';
import 'package:hook_up_rent/widgets/common_radio_form_item.dart';
import 'package:hook_up_rent/widgets/common_select_form_item.dart';
import 'package:hook_up_rent/widgets/common_title.dart';
import 'package:hook_up_rent/widgets/room_appliance.dart';

class RoomAddPage extends StatefulWidget {
  const RoomAddPage({Key key}) : super(key: key);

  @override
  _RoomAddPageState createState() => _RoomAddPageState();
}

class _RoomAddPageState extends State<RoomAddPage> {
  final _formKey = new GlobalKey<FormState>();
  List<GeneralType> floorList = [];
  List<GeneralType> orientedList = [];
  List<GeneralType> roomTypeList = [];
  int rentType = 0;
  int decorationType = 0;
  int roomType = 0;
  int floor = 0;
  int oriented = 0;
  List<File> images = [];

  Community community;

  List<RoomApplianceItem> applianceList = [];

  var titleController = TextEditingController();
  var descController = TextEditingController();

  var sizeController = TextEditingController();
  var priceController = TextEditingController();

  _getParams() async {
    String url = '/houses/params';

    //θΏεε€η
    var res = await DioHttp.of(context).get(url);

    var data = json.decode(res.toString())['body'];
    List<GeneralType> floorList = List<GeneralType>.from(
        data['floor'].map((item) => GeneralType.fromJson(item)).toList());
    List<GeneralType> orientedList = List<GeneralType>.from(
        data['oriented'].map((item) => GeneralType.fromJson(item)).toList());
    List<GeneralType> roomTypeList = List<GeneralType>.from(
        data['roomType'].map((item) => GeneralType.fromJson(item)).toList());

    setState(() {
      this.floorList = floorList;
      this.orientedList = orientedList;
      this.roomTypeList = roomTypeList;
    });
  }

  @override
  void initState() {
    Timer.run(_getParams);
    super.initState();
  }

  _submit() async {
    var size = sizeController.text;
    var price = priceController.text;

    if (stringIsNullOrEmpty(size)) {
      CommonToast.showToast('γε€§ε°γδΈθ½δΈΊη©Ί');
      return;
    }
    if (stringIsNullOrEmpty(price)) {
      CommonToast.showToast('γη§ιγδΈθ½δΈΊη©Ί');
      return;
    }
    if (null == community) {
      CommonToast.showToast('γε°εΊγδΈθ½δΈΊη©Ί');
      return;
    }

    //ζ₯ε£url
    String url = '/user/houses';

    var imageString = await uploadImages(images, context);

    //εζ°
    Map<String, dynamic> params = {
      "title": titleController.text,
      "description": descController.text,
      "price": price,
      "size": size,
      "oriented": orientedList[oriented].id,
      "roomType": roomTypeList[roomType].id,
      "floor": floorList[floor].id,
      "community": community.id,
      "houseImg": imageString, //ε€ζ‘δ»₯ ο½ εε²
      "supporting":
          applianceList.map((item) => item.title).join('|'), //ε€ζ‘δ»₯ ο½ εε²
    };
    var token = ScopedModelHelper.getModel<AuthModel>(context).token;
//ζ°ζ?θΏε
    var res = await DioHttp.of(context).post(url, params, token);
    var status = json.decode(res.toString())['status'];
    if (status.toString().startsWith('2')) {
      CommonToast.showToast('ζΏζΊεεΈζε');
      bool isSubmitted = true;
      Navigator.of(context).pop(isSubmitted);
    } else {
      var description = json.decode(res.toString())['description'];
      CommonToast.showToast(description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ζΏζΊεεΈ'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CommonTitle('ζΏζΊδΏ‘ζ―'),
              CommonFormItem(
                label: 'ε°εΊ',
                contentBuilder: (context) {
                  return Container(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        height: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              community?.name ?? 'θ―·ιζ©ε°εΊ',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        ),
                      ),
                      onTap: () {
                        var result =
                            Navigator.of(context).pushNamed('communityPicker');

                        result.then((value) {
                          if (null != value)
                            setState(() {
                              community = value;
                            });
                        });
                      },
                    ),
                  );
                },
              ),
              CommonFormItem(
                label: 'η§ι',
                hintText: 'θ―·θΎε₯η§ι',
                suffixText: 'ε/ζ',
                controller: priceController,
              ),
              CommonFormItem(
                label: 'ε€§ε°',
                hintText: 'θ―·θΎε₯ζΏε±ε€§ε°',
                suffixText: 'εΉ³ζΉη±³',
                controller: sizeController,
              ),
              CommonRadioFormItem(
                  label: 'η§θ΅ζΉεΌ',
                  options: ['εη§', 'ζ΄η§'],
                  value: rentType,
                  onChange: (index) {
                    setState(() {
                      rentType = index;
                    });
                  }),
              if (roomTypeList.length > 0)
                CommonSelectFormItem(
                  label: 'ζ·ε',
                  value: roomType,
                  onChange: (val) {
                    setState(() {
                      roomType = val;
                    });
                  },
                  options: roomTypeList.map((item) => item.name).toList(),
                ),
              if (floorList.length > 0)
                CommonSelectFormItem(
                  label: 'ζ₯Όε±',
                  value: floor,
                  onChange: (val) {
                    setState(() {
                      floor = val;
                    });
                  },
                  options: floorList.map((item) => item.name).toList(),
                ),
              if (orientedList.length > 0)
                CommonSelectFormItem(
                  label: 'ζε',
                  value: oriented,
                  onChange: (val) {
                    setState(() {
                      oriented = val;
                    });
                  },
                  options: orientedList.map((item) => item.name).toList(),
                ),
              CommonRadioFormItem(
                  label: 'θ£δΏ?',
                  options: ['η²Ύθ£', 'η?θ£'],
                  value: decorationType,
                  onChange: (index) {
                    setState(() {
                      decorationType = index;
                    });
                  }),
              CommonTitle('ζΏε±εΎε'),
              CommonImagePicker(
                onChange: (List<File> files) {
                  setState(() {
                    images = files;
                  });
                },
              ),
              CommonTitle('ζΏε±ζ ι’'),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'θ―·θΎε₯ζ ι’οΌδΎε¦οΌζ΄η»οΌε°εΊε 2ε?€ 2000εοΌ',
                  ),
                ),
              ),
              CommonTitle('ζΏε±ιη½?'),
              RoomAppliance(
                onChange: (data) {
                  applianceList = data;
                },
              ),
              CommonTitle('ζΏε±ζθΏ°'),
              Container(
                margin: EdgeInsets.only(bottom: 100.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: descController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'θ―·θΎε₯ζΏε±ζθΏ°δΏ‘ζ―',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CommonFloatingActionButton('ζδΊ€', _submit),
    );
  }
}
