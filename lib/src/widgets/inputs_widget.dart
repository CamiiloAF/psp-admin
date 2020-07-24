import 'package:country_code_picker/country_code_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';

class InputEmail extends StatelessWidget {
  final bool hasError;
  final bool withIcon;
  final String initialValue;

  final Function(String value) onChange;
  final Function(String value) onSaved;
  final String Function(String) validator;

  InputEmail({
    this.hasError = false,
    this.withIcon = true,
    this.initialValue,
    this.onChange,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeChanger>(context).isDarkTheme;
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            icon: (withIcon)
                ? Icon(Icons.email,
                    color: (isDarkTheme)
                        ? Colors.white.withOpacity(0.6)
                        : Theme.of(context).primaryColor)
                : null,
            hintText: S.of(context).hintEmail,
            labelText: S.of(context).labelEmail,
            errorText: (hasError) ? S.of(context).invalidEmail : null),
        onChanged: onChange,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}

class InputPassword extends StatefulWidget {
  final bool hasError;
  final bool withIcon;
  final String label;
  final String errorText;

  final Function(String value) onChange;
  final String Function(String value) validator;
  final Function(String) onSaved;

  InputPassword({
    this.hasError = false,
    this.withIcon = true,
    this.label,
    this.errorText,
    this.onChange,
    this.validator,
    this.onSaved,
  });

  @override
  _InputPasswordState createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeChanger>(context).isDarkTheme;

    var finalErrorText = (widget.errorText == null)
        ? S.of(context).invalidPassword
        : widget.errorText;

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextFormField(
        obscureText: _obscureText,
        decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(
                    (_obscureText) ? Icons.visibility : Icons.visibility_off),
                onPressed: _changePasswordVisibility),
            icon: (widget.withIcon)
                ? Icon(
                    Icons.lock_outline,
                    color: (isDarkTheme)
                        ? Colors.white.withOpacity(0.6)
                        : Theme.of(context).primaryColor,
                  )
                : null,
            labelText: (widget.label == null)
                ? S.of(context).labelPassword
                : widget.label,
            errorText: (widget.hasError) ? finalErrorText : null),
        onChanged: widget.onChange,
        validator: widget.validator,
        onSaved: widget.onSaved,
      ),
    );
  }

  void _changePasswordVisibility() =>
      setState(() => _obscureText = !_obscureText);
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
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
        initialValue: initialValue,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText:
                (labelHint == null) ? S.of(context).labelName : labelHint,
            counterText: '$counter/50',
            errorText: errorText),
        keyboardType: TextInputType.text,
        maxLength: 50,
        onChanged: onChange,
        validator: onChange,
        onSaved: onSaved,
      ),
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
  final bool isEnabled;

  final DateTime initialValue;
  final Function(DateTime) onSaved;

  InputDate(
      {this.isRequired = false,
      @required this.labelAndHint,
      this.onSaved,
      this.initialValue,
      this.isEnabled = true});

  @override
  _InputDateState createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  final TextEditingController textEditingController = TextEditingController();
  bool haveError = false;

  @override
  Widget build(BuildContext context) {
    if (textEditingController.text.isEmpty && widget.initialValue != null) {
      textEditingController.text = Constants.format.format(widget.initialValue);
    }

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: DateTimeField(
          initialValue: widget.initialValue,
          format: Constants.format,
          controller: textEditingController,
          enabled: widget.isEnabled,
          decoration: buildInputDecoration(context, Constants.format),
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
  final Function(String) onChange;
  final Function(CountryCode) onChangeCountryPicker;
  final Function(String) onSaved;
  final String Function(String) validator;

  InputPhoneWithCountryPicker(
      {this.countryCode,
      this.initialValue,
      this.hasError = false,
      this.onChange,
      this.validator,
      this.onSaved,
      this.onChangeCountryPicker});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 48 / 5),
            width: MediaQuery.of(context).size.width * 0.2,
            child: CountryCodePicker(
              onChanged: onChangeCountryPicker,
              initialSelection: countryCode,
              showCountryOnly: false,
              alignLeft: true,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 10),
              child: TextFormField(
                initialValue: initialValue,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: S.of(context).labelPhone,
                    errorText:
                        (hasError) ? S.of(context).invalidNumber : null),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onChanged: onChange,
                validator: validator,
                onSaved: onSaved,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class InputForm extends StatelessWidget {
  final String initialValue;
  final int maxLength;
  final int maxLines;

  final String label;
  final String helper;

  final bool isEnabled;
  final bool isReadOnly;

  final TextEditingController controller;
  final TextInputType keyboardType;

  final EdgeInsetsGeometry margin;

  final Function(String value) onSaved;

  final String Function(String value) onChanged;
  final String Function(String value) validator;

  InputForm({
    @required this.label,
    this.initialValue,
    this.helper,
    this.maxLength,
    this.maxLines,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.controller,
    this.keyboardType,
    this.onSaved,
    this.onChanged,
    this.margin,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: (margin == null) ? EdgeInsets.only(top: 20) : margin,
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          helperText: helper,
        ),
        onSaved: onSaved,
        enabled: isEnabled,
        maxLength: maxLength,
        maxLines: maxLines,
        readOnly: isReadOnly,
        onChanged: onChanged,
        validator: (validator != null) ? validator : onChanged,
      ),
    );
  }

  static Widget buildReadOnlyInput(String label, String initialValue,
      {String helper}) {
    return InputForm(
      label: label,
      isReadOnly: true,
      helper: helper,
      initialValue: initialValue,
    );
  }
}

class CustomInput extends StatefulWidget {
  final String errorText;
  final String initialValue;
  final String label;

  final bool Function(String value) onChanged;
  final String Function(String value) validator;
  final Function(String value) onSaved;

  final TextInputType keyboardType;

  final bool isEnabled;
  final bool isReadOnly;

  final int maxLines;
  final int minLines;

  CustomInput({
    this.errorText,
    @required this.label,
    this.onChanged,
    this.validator,
    @required this.onSaved,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.isEnabled = true,
    this.isReadOnly = true,
    this.maxLines = 1,
    this.minLines = 1,
  });

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
        initialValue: widget.initialValue,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            labelText: widget.label,
            errorText: (hasError) ? widget.errorText : null),
        keyboardType: widget.keyboardType,
        onChanged: (widget.onChanged == null)
            ? null
            : (value) {
                setState(() => hasError = widget.onChanged(value));
              },
        validator: widget.validator,
        onSaved: widget.onSaved,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
      ),
    );
  }
}
