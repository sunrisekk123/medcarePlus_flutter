import 'package:flutter/material.dart';
import 'package:fyp/views/services/loginService.dart';
import 'package:fyp/models/common.dart';
import 'package:fyp/views/common/loader.dart';
import 'package:gap/gap.dart';

class RegisterClinicArea extends StatefulWidget {
  static const String routeName = '/register_clinic';

  const RegisterClinicArea({Key? key}) : super(key: key);

  @override
  State<RegisterClinicArea> createState() => _RegisterClinicAreasState();
}

class _RegisterClinicAreasState extends State<RegisterClinicArea> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool isChecked = false;
  String _area = "";
  String _district = "";
  final LoginService loginService = LoginService();
  final _nameController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  List<District> districtListOri = [];
  List<District> districtList = [];
  List<TextValue> areaList = [
    TextValue("Hong Kong Island", "HK"),
    TextValue("Kowloon", "KL"),
    TextValue("New Territories", "NT")
  ];

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleConfirmVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDistrictOptions();
  }

  fetchDistrictOptions() async {
    List<District> list = await loginService.getDistrictOptions(context);
    List<District> resultList = [];
    for (var element in list) {
      if (element.area == areaList[0].value) {
        resultList.add(element);
      }
    }
    setState(() {
      _area = areaList[0].value;
      _district = resultList[0].district;
      districtList = resultList;
      districtListOri = list;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneNoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _area = "";
    _district = "";
  }

  void registerClinic() {
    loginService.registerClinic(
        context: context,
        area: _area,
        district: _district,
        address: _addressController.text,
        email: _emailController.text,
        walletAddress: "",
        password: _passwordController.text,
        name: _nameController.text,
        phoneNo: _phoneNoController.text);
  }

  @override
  Widget build(BuildContext context) {
    Color checkboxColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return const Color(0xffD3D6DA);
      }
      return const Color(0xFFE68453);
    }

    return Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              "Register an clinic account",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Color(0xFF303030)),
            )
          ]),
          leading: IconButton(
            icon: const Icon(Icons.clear_rounded, color: Color(0xFF303030)),
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName('/login')),
          ),
        ),
        body: !_district.isNotEmpty
            ? const Loader()
            : SafeArea(
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        // onChanged: () {
                        //   Form.of(primaryFocus!.context!)!.save();
                        // },
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, 2),
                                  child: Text(
                                    "Please fill in the information and wait for identity verification",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF303030)),
                                  )),
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 2, 20, 5),
                                  child: Text(
                                    "(*Mandatory field)",
                                    style: TextStyle(
                                        fontSize: 13, color: Color(0xFFe34c32)),
                                  )),
                              Row(
                                children: [
                                  Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 5, 0),
                                          child: TextFormField(
                                            autofocus: false,
                                            controller: _nameController,
                                            decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 7),
                                                labelText: 'Clinic Name *',
                                                labelStyle:
                                                    TextStyle(fontSize: 14)),
                                            validator: (v) {
                                              return v!.trim().isNotEmpty
                                                  ? null
                                                  : "Name cannot be empty";
                                            },
                                          ))),
                                  Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 20, 0),
                                          child: TextFormField(
                                            autocorrect: false,
                                            controller: _phoneNoController,
                                            enableSuggestions: false,
                                            autofocus: false,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 7),
                                                labelText: 'Phone Number *',
                                                labelStyle:
                                                    TextStyle(fontSize: 14),
                                                prefixText: '+852 '),
                                            validator: (v) {
                                              return phoneNumberValidator(v);
                                            },
                                          )))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: Column(
                                          children: [
                                            Gap(10),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Area',
                                                  style: TextStyle(fontSize: 11, color: Colors.black), textAlign: TextAlign.start,
                                                )
                                            ),
                                            DropdownButtonFormField(
                                                value: areaList[0].value,
                                                icon: const Icon(Icons.arrow_downward),
                                                elevation: 12,
                                                isExpanded: true,
                                                style: TextStyle(fontSize: 13, color: Colors.black),
                                                onChanged: (value) {
                                                  List<District> oriList =
                                                      districtListOri;
                                                  List<District> resultList = [];
                                                  for (var element in oriList) {
                                                    if (element.area == value) {
                                                      resultList.add(element);
                                                    }
                                                  }
                                                  setState(() {
                                                    _area = value.toString();
                                                    _district = resultList[0].district;
                                                    districtList = resultList;
                                                  });
                                                },
                                                validator: (value) => value == null ? "Area cannot be empty" : null,
                                                items: areaList.map(
                                                        (e) => DropdownMenuItem<String>(
                                                        value: e.value,
                                                        child: Row(children: [Text(e.text)],
                                                        ))
                                                ).toList()),
                                          ],
                                        )
                                    ),
                                    Flexible(
                                        child: Column(
                                          children: [
                                            Gap(10),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'District',
                                                style: TextStyle(fontSize: 11, color: Colors.black), textAlign: TextAlign.start,
                                              )
                                            ),
                                            DropdownButtonFormField(
                                                value: _district.isNotEmpty ? _district : districtList[0].district,
                                                icon: const Icon(Icons.arrow_downward),
                                                style: TextStyle(fontSize: 13, color: Colors.black),
                                                elevation: 12,
                                                isExpanded: true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _district =
                                                        value.toString();
                                                  });
                                                },
                                                items: districtList.map((e) =>
                                                    DropdownMenuItem<String>(
                                                        value: e.district,
                                                        child: Row(
                                                          children: [
                                                            Text(e.district)
                                                          ],
                                                        ))).toList()),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextFormField(
                                    autofocus: false,
                                    controller: _addressController,
                                    decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: 7),
                                        labelText: 'Address *',
                                        labelStyle: TextStyle(fontSize: 14)),
                                    validator: (v) {
                                      return v!.trim().isNotEmpty
                                          ? null
                                          : "Address cannot be empty";
                                    },
                                  )),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextFormField(
                                    autofocus: false,
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 7),
                                        labelText: 'Email *',
                                        labelStyle: TextStyle(fontSize: 14)),
                                    validator: (v) {
                                      return emailValidator(v);
                                    },
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  autocorrect: false,
                                  obscureText: !_showPassword,
                                  enableSuggestions: false,
                                  autofocus: false,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    labelText: 'Password *',
                                    labelStyle: TextStyle(fontSize: 14),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        _toggleVisibility();
                                      },
                                      child: Icon(
                                        _showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ),
                                  validator: (v) {
                                    return passwordValidator(v);
                                  },
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                  child: Text(
                                    "(Password should be within 8-16 characters and contain at least one number , one uppercase letter and one lowercase letter)",
                                    style: TextStyle(
                                        fontSize: 11, color: Color(0xFF303030)),
                                  )),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 5, 20, 0),
                                  child: TextFormField(
                                    autocorrect: false,
                                    obscureText: !_showConfirmPassword,
                                    enableSuggestions: false,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5),
                                      labelText: 'Confirm Password *',
                                      labelStyle: TextStyle(fontSize: 14),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          _toggleConfirmVisibility();
                                        },
                                        child: Icon(
                                          _showConfirmPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ),
                                    validator: (v) {
                                      return confirmPasswordValidator(v);
                                    },
                                  )),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: CheckboxListTile(
                                  checkColor: Colors.white,
                                  title: RichText(
                                    maxLines: 10,
                                    softWrap: true,
                                    text: TextSpan(
                                      text: "I agree to the MedCare Plus",
                                      style: const TextStyle(
                                          color: Color(0xFF717784),
                                          fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: " Terms of Service ",
                                          style: const TextStyle(
                                            color: Color(0xFFE68453),
                                          ),
                                          // recognizer: TapGestureRecognizer()
                                          //   ..onTap = () => Navigator.of(context).push(MaterialPageRoute(
                                          //       builder: (context) => const RegisterPageDetails()))
                                        ),
                                        const TextSpan(
                                          text: " and ",
                                          style: TextStyle(
                                              color: Color(0xFF717784)),
                                        ),
                                        TextSpan(
                                          text: "Privacy Policy",
                                          style: const TextStyle(
                                            color: Color(0xFFE68453),
                                          ),
                                          // recognizer: TapGestureRecognizer()
                                          //   ..onTap = () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPageDetails()))
                                        ),
                                      ],
                                    ),
                                  ),
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity
                                      .leading, //  <-- leading Checkbox
                                ),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Row(children: <Widget>[
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            registerClinic();
                                          }
                                        },
                                        child: const Text('Submit'),
                                      ),
                                    )
                                  ])
                              ),
                            ]
                        )
                    )
                )
        )
    );
  }

  String? emailValidator(v) {
    String? temp;
    if (v!.trim().isNotEmpty) {
      final check = RegExp(
          r"^[a-z0-9!#$%&'*+-/=?^_`{|}~]+@[a-z0-9!#$%&'*+-/=?^_`{|}~]+$");
      if (check.hasMatch(v)) {
        temp = null;
      } else {
        temp = "Invalid email address";
      }
    } else {
      temp = "Email cannot be empty";
    }
    return temp;
  }

  String? passwordValidator(v) {
    String? temp;
    if (v!.trim().isNotEmpty) {
      if (v!.trim().length < 8 || v!.trim().length > 16) {
        temp = "Invalid password";
      } else {
        final check = RegExp(r"(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])");
        if (check.hasMatch(v)) {
          temp = null;
        } else {
          temp = "Invalid password";
        }
      }
    } else {
      temp = "Password cannot be empty";
    }
    return temp;
  }

  String? confirmPasswordValidator(v) {
    String? temp;
    if (v!.trim().isNotEmpty) {
      if (_passwordController.text.trim() != v.trim()) {
        temp = "Invalid password";
      } else {
        temp = null;
      }
    } else {
      temp = "Password cannot be empty";
    }

    return temp;
  }

  String? phoneNumberValidator(v) {
    String? temp;
    if (v!.trim().isNotEmpty) {
      if (v!.trim().length != 8) {
        temp = "Invalid phone number format";
      } else {
        temp = null;
      }
    } else {
      temp = "Phone No cannot be empty";
    }
    return temp;
  }
}
