import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psp_admin/generated/l10n.dart';

Widget inputEmail(
    BuildContext context, bool hasError, Function(String value) onChange) {
  return TextField(
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
        icon: Icon(Icons.email, color: Theme.of(context).primaryColor),
        hintText: S.of(context).hintEmail,
        labelText: S.of(context).labelEmail,
        errorText: (hasError) ? S.of(context).invalidEmail : null),
    onChanged: onChange,
  );
}

Widget inputPassword(
    BuildContext context, bool hasError, Function(String value) onChange) {
  return TextField(
    obscureText: true,
    decoration: InputDecoration(
        icon: Icon(
          Icons.lock_outline,
          color: Theme.of(context).primaryColor,
        ),
        labelText: S.of(context).labelPassword,
        errorText: (hasError) ? S.of(context).invalidPassword : null),
    onChanged: onChange,
  );
}

class InputName extends StatelessWidget {
  final String counter;
  final String errorText;
  final String initialValue;

  final String Function(String value) onChange;
  final Function(String value) onSaved;

  InputName({
    @required this.onSaved,
    this.counter = '50',
    this.errorText,
    this.onChange,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: S.of(context).hintLabelName,
          labelText: S.of(context).hintLabelName,
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
    return TextFormField(
      initialValue: initialValue,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: S.of(context).hintLabelDescription,
          labelText: S.of(context).hintLabelDescription,
          errorText: errorText),
      keyboardType: TextInputType.multiline,
      onChanged: onChange,
      validator: onChange,
      onSaved: onSaved,
      maxLines: 5,
      minLines: 1,
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
    return DateTimeField(
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
        });
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
        hintText: widget.labelAndHint,
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
