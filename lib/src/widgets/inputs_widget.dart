import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psp_admin/generated/l10n.dart';

class InputEmail extends StatelessWidget {
  final bool hasError;
  final Function(String value) onChange;
  final bool withIcon;

  InputEmail({this.hasError, this.onChange, this.withIcon = true});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          icon: (withIcon)
              ? Icon(Icons.email, color: Theme.of(context).primaryColor)
              : null,
          hintText: S.of(context).hintEmail,
          labelText: S.of(context).labelEmail,
          errorText: (hasError) ? S.of(context).invalidEmail : null),
      onChanged: onChange,
    );
  }
}

class InputPassword extends StatelessWidget {
  final bool hasError;
  final Function(String value) onChange;
  final bool withIcon;
  final String label;

  InputPassword(
      {this.hasError, this.onChange, this.withIcon = true, this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
          icon: (withIcon)
              ? Icon(
                  Icons.lock_outline,
                  color: Theme.of(context).primaryColor,
                )
              : null,
          labelText: (label == null) ? S.of(context).labelPassword : label,
          errorText: (hasError) ? S.of(context).invalidPassword : null),
      onChanged: onChange,
    );
  }
}

class InputName extends StatelessWidget {
  final String counter;
  final String errorText;
  final String initialValue;
  final String labelHint;

  final String Function(String value) onChange;
  final Function(String value) onSaved;

  InputName({
    @required this.onSaved,
    this.counter = '50',
    this.errorText,
    this.onChange,
    this.initialValue,
    this.labelHint,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          labelText: (labelHint == null) ? S.of(context).labelName : labelHint,
          counterText: '$counter/50',
          errorText: errorText),
      keyboardType: TextInputType.text,
      maxLength: 50,
      onChanged: onChange,
      validator: onChange,
      onSaved: onSaved,
    );
  }
}

class InputDescription extends StatelessWidget {
  final TextEditingController textEditingController = TextEditingController();

  final String errorText;
  final String initialValue;
  final String Function(String value) onChange;
  final Function(String value) onSaved;

  InputDescription(
      {this.errorText, this.onChange, this.onSaved, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
        initialValue: initialValue,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: S.of(context).labelDescription, errorText: errorText),
        keyboardType: TextInputType.multiline,
        onChanged: onChange,
        validator: onChange,
        onSaved: onSaved,
        maxLines: 5,
        minLines: 1,
      ),
    );
  }
}

class InputDate extends StatefulWidget {
  final String labelAndHint;
  final bool isRequired;
  final DateTime initialValue;
  final Function(DateTime) onSaved;

  InputDate(
      {this.isRequired = false,
      @required this.labelAndHint,
      @required this.onSaved,
      this.initialValue});

  @override
  _InputDateState createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  final TextEditingController textEditingController = TextEditingController();
  bool haveError = false;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('yyyy-MM-dd HH:mm');
    if (textEditingController.text.isEmpty && widget.initialValue != null) {
      textEditingController.text = format.format(widget.initialValue);
    }

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: DateTimeField(
          initialValue: widget.initialValue,
          format: format,
          controller: textEditingController,
          decoration: buildInputDecoration(context, format),
          onShowPicker: _onShowPicker,
          onChanged: (widget.isRequired)
              ? (value) {
                  if (value == null) {
                    setState(() => haveError = true);
                  } else {
                    setState(() => haveError = false);
                  }
                }
              : null,
          onSaved: (value) => {widget.onSaved(value)},
          validator: (DateTime value) {
            if (value == null && widget.isRequired) {
              haveError = true;
              return S.of(context).inputRequiredError;
            } else {
              setState(() => haveError = false);
              return null;
            }
          }),
    );
  }

  InputDecoration buildInputDecoration(
      BuildContext context, DateFormat format) {
    return InputDecoration(
        helperText: S.of(context).helperInputDate,
        prefixIcon: GestureDetector(
          child: Icon(Icons.today),
          onLongPress: () {
            setState(() =>
                textEditingController.text = format.format(DateTime.now()));
          },
        ),
        labelText: widget.labelAndHint,
        errorText: (haveError) ? S.of(context).inputRequiredError : null);
  }

  Future<DateTime> _onShowPicker(context, currentValue) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: currentValue ?? DateTime.now(),
        lastDate: DateTime(2100));
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
      );
      return DateTimeField.combine(date, time);
    } else {
      return currentValue;
    }
  }
}

class InputPhoneWithCountryPicker extends StatelessWidget {
  final String countryCode;
  final String initialValue;
  final bool hasError;
  final String Function(String value) onChange;
  final Function(String value) onSaved;

  InputPhoneWithCountryPicker(
      {this.countryCode,
      this.initialValue,
      this.hasError = false,
      this.onChange,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 48 / 2),
            width: MediaQuery.of(context).size.width * 0.2,
            child: CountryCodePicker(
              onChanged: (value) {
                print(value);
              },
              initialSelection: S.of(context).countryCode,
              showCountryOnly: false,
              alignLeft: true,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 20, left: 10),
              child: TextFormField(
                initialValue: initialValue,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: S.of(context).labelPhone,
                    errorText:
                        (hasError) ? S.of(context).inputPhoneError : null),
                keyboardType: TextInputType.phone,
                maxLength: 15,
                onChanged: onChange,
                validator: onChange,
                onSaved: onSaved,
              ),
            ),
          )
        ],
      ),
    );
  }
}
