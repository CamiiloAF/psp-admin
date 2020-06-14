// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Ingreso Administrador`
  String get loginFormTitle {
    return Intl.message(
      'Ingreso Administrador',
      name: 'loginFormTitle',
      desc: '',
      args: [],
    );
  }

  /// `Ingresar`
  String get loginButton {
    return Intl.message(
      'Ingresar',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `ejemplo@correo.com`
  String get hintEmail {
    return Intl.message(
      'ejemplo@correo.com',
      name: 'hintEmail',
      desc: '',
      args: [],
    );
  }

  /// `Correo electrónico`
  String get labelEmail {
    return Intl.message(
      'Correo electrónico',
      name: 'labelEmail',
      desc: '',
      args: [],
    );
  }

  /// `Contraseña`
  String get labelPassword {
    return Intl.message(
      'Contraseña',
      name: 'labelPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email inválido`
  String get invalidEmail {
    return Intl.message(
      'Email inválido',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Se requieren 8 o más caractéres`
  String get invalidPassword {
    return Intl.message(
      'Se requieren 8 o más caractéres',
      name: 'invalidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Falló el login`
  String get dialogTitleLoginFailed {
    return Intl.message(
      'Falló el login',
      name: 'dialogTitleLoginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Aceptar`
  String get dialogButtonOk {
    return Intl.message(
      'Aceptar',
      name: 'dialogButtonOk',
      desc: '',
      args: [],
    );
  }

  /// `Proyectos`
  String get appBarTitleProjects {
    return Intl.message(
      'Proyectos',
      name: 'appBarTitleProjects',
      desc: '',
      args: [],
    );
  }

  /// `NO ESTÁS AUTORIZADO`
  String get titleNotAutorized {
    return Intl.message(
      'NO ESTÁS AUTORIZADO',
      name: 'titleNotAutorized',
      desc: '',
      args: [],
    );
  }

  /// `Cargando`
  String get progressDialogLoading {
    return Intl.message(
      'Cargando',
      name: 'progressDialogLoading',
      desc: '',
      args: [],
    );
  }

  /// `Guardando`
  String get progressDialogSaving {
    return Intl.message(
      'Guardando',
      name: 'progressDialogSaving',
      desc: '',
      args: [],
    );
  }

  /// `Por favor revise su conexión a internet`
  String get messageNotConnection {
    return Intl.message(
      'Por favor revise su conexión a internet',
      name: 'messageNotConnection',
      desc: '',
      args: [],
    );
  }

  /// `Actualizado con éxito`
  String get message204Update {
    return Intl.message(
      'Actualizado con éxito',
      name: 'message204Update',
      desc: '',
      args: [],
    );
  }

  /// `Solicitud creada incorrectamente`
  String get message400 {
    return Intl.message(
      'Solicitud creada incorrectamente',
      name: 'message400',
      desc: '',
      args: [],
    );
  }

  /// `No autorizado para solicitar recursos`
  String get message401 {
    return Intl.message(
      'No autorizado para solicitar recursos',
      name: 'message401',
      desc: '',
      args: [],
    );
  }

  /// `No tienes suficientes permisos`
  String get message403 {
    return Intl.message(
      'No tienes suficientes permisos',
      name: 'message403',
      desc: '',
      args: [],
    );
  }

  /// `No se econtró información`
  String get message404 {
    return Intl.message(
      'No se econtró información',
      name: 'message404',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred`
  String get messageUnexpectedError {
    return Intl.message(
      'An unexpected error occurred',
      name: 'messageUnexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `Credenciales incorrectas`
  String get messageIncorrectCredentials {
    return Intl.message(
      'Credenciales incorrectas',
      name: 'messageIncorrectCredentials',
      desc: '',
      args: [],
    );
  }

  /// `No hay información`
  String get thereIsNoInformation {
    return Intl.message(
      'No hay información',
      name: 'thereIsNoInformation',
      desc: '',
      args: [],
    );
  }

  /// `Nombre`
  String get hintLabelName {
    return Intl.message(
      'Nombre',
      name: 'hintLabelName',
      desc: '',
      args: [],
    );
  }

  /// `Debe tener al menos 3 carateres`
  String get inputNameError {
    return Intl.message(
      'Debe tener al menos 3 carateres',
      name: 'inputNameError',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get hintLabelDescription {
    return Intl.message(
      'Description',
      name: 'hintLabelDescription',
      desc: '',
      args: [],
    );
  }

  /// `Este campo es obligatorio`
  String get inputRequiredError {
    return Intl.message(
      'Este campo es obligatorio',
      name: 'inputRequiredError',
      desc: '',
      args: [],
    );
  }

  /// `Fecha de planeación`
  String get hintLabelPlanningDate {
    return Intl.message(
      'Fecha de planeación',
      name: 'hintLabelPlanningDate',
      desc: '',
      args: [],
    );
  }

  /// `Fecha de inicio`
  String get hintLabelStartDate {
    return Intl.message(
      'Fecha de inicio',
      name: 'hintLabelStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Fecha de finalización`
  String get hintLabelFinishDate {
    return Intl.message(
      'Fecha de finalización',
      name: 'hintLabelFinishDate',
      desc: '',
      args: [],
    );
  }

  /// `Mantenga presionado el icono para poner la fecha y hora actual`
  String get helperInputDate {
    return Intl.message(
      'Mantenga presionado el icono para poner la fecha y hora actual',
      name: 'helperInputDate',
      desc: '',
      args: [],
    );
  }

  /// `Guardar`
  String get save {
    return Intl.message(
      'Guardar',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Cerrar sesión`
  String get optionLogOut {
    return Intl.message(
      'Cerrar sesión',
      name: 'optionLogOut',
      desc: '',
      args: [],
    );
  }

  /// `Ajustes`
  String get optionSettings {
    return Intl.message(
      'Ajustes',
      name: 'optionSettings',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}