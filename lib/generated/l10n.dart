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

  /// `Confirmar Contraseña`
  String get labelConfirmPassword {
    return Intl.message(
      'Confirmar Contraseña',
      name: 'labelConfirmPassword',
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

  /// `Las contraseñas no coinciden`
  String get invalidConfirmPassword {
    return Intl.message(
      'Las contraseñas no coinciden',
      name: 'invalidConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Número inválido`
  String get invalidNumber {
    return Intl.message(
      'Número inválido',
      name: 'invalidNumber',
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

  /// `Cancelar`
  String get dialogButtonCancel {
    return Intl.message(
      'Cancelar',
      name: 'dialogButtonCancel',
      desc: '',
      args: [],
    );
  }

  /// `Recuperar`
  String get dialogButtonRecover {
    return Intl.message(
      'Recuperar',
      name: 'dialogButtonRecover',
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

  /// `Items del proyecto`
  String get appBarTitleProjectItems {
    return Intl.message(
      'Items del proyecto',
      name: 'appBarTitleProjectItems',
      desc: '',
      args: [],
    );
  }

  /// `Modulos`
  String get appBarTitleModules {
    return Intl.message(
      'Modulos',
      name: 'appBarTitleModules',
      desc: '',
      args: [],
    );
  }

  /// `Usuarios`
  String get appBarTitleUsers {
    return Intl.message(
      'Usuarios',
      name: 'appBarTitleUsers',
      desc: '',
      args: [],
    );
  }

  /// `Usuarios de la organización`
  String get appBarTitleUsersByOrganization {
    return Intl.message(
      'Usuarios de la organización',
      name: 'appBarTitleUsersByOrganization',
      desc: '',
      args: [],
    );
  }

  /// `Programas`
  String get appBarTitlePrograms {
    return Intl.message(
      'Programas',
      name: 'appBarTitlePrograms',
      desc: '',
      args: [],
    );
  }

  /// `Partes base`
  String get appBarTitleBaseParts {
    return Intl.message(
      'Partes base',
      name: 'appBarTitleBaseParts',
      desc: '',
      args: [],
    );
  }

  /// `Partes nuevas`
  String get appBarTitleNewParts {
    return Intl.message(
      'Partes nuevas',
      name: 'appBarTitleNewParts',
      desc: '',
      args: [],
    );
  }

  /// `Partes reutilizables`
  String get appBarTitleReusableParts {
    return Intl.message(
      'Partes reutilizables',
      name: 'appBarTitleReusableParts',
      desc: '',
      args: [],
    );
  }

  /// `Log de Defectos`
  String get appBarTitleDefectLogs {
    return Intl.message(
      'Log de Defectos',
      name: 'appBarTitleDefectLogs',
      desc: '',
      args: [],
    );
  }

  /// `Log de tiempos`
  String get appBarTitleTimeLogs {
    return Intl.message(
      'Log de tiempos',
      name: 'appBarTitleTimeLogs',
      desc: '',
      args: [],
    );
  }

  /// `Reportes de prueba`
  String get appBarTitleTestReports {
    return Intl.message(
      'Reportes de prueba',
      name: 'appBarTitleTestReports',
      desc: '',
      args: [],
    );
  }

  /// `Lenguajes`
  String get appBarTitleLanguages {
    return Intl.message(
      'Lenguajes',
      name: 'appBarTitleLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Perfil`
  String get appBarTitleProfile {
    return Intl.message(
      'Perfil',
      name: 'appBarTitleProfile',
      desc: '',
      args: [],
    );
  }

  /// `Experiencias`
  String get appBarTitleExperiences {
    return Intl.message(
      'Experiencias',
      name: 'appBarTitleExperiences',
      desc: '',
      args: [],
    );
  }

  /// `Usuarios Libres`
  String get appBarTitleFreeUsers {
    return Intl.message(
      'Usuarios Libres',
      name: 'appBarTitleFreeUsers',
      desc: '',
      args: [],
    );
  }

  /// `Herramientas de análisis`
  String get appBarTitleAnalysisTools {
    return Intl.message(
      'Herramientas de análisis',
      name: 'appBarTitleAnalysisTools',
      desc: '',
      args: [],
    );
  }

  /// `NO ESTÁS AUTORIZADO`
  String get titleNotAuthorized {
    return Intl.message(
      'NO ESTÁS AUTORIZADO',
      name: 'titleNotAuthorized',
      desc: '',
      args: [],
    );
  }

  /// `Total de tiempos`
  String get titleTotalTimes {
    return Intl.message(
      'Total de tiempos',
      name: 'titleTotalTimes',
      desc: '',
      args: [],
    );
  }

  /// `Defectos inyectados por fase`
  String get titleDefectsInjectedByPhase {
    return Intl.message(
      'Defectos inyectados por fase',
      name: 'titleDefectsInjectedByPhase',
      desc: '',
      args: [],
    );
  }

  /// `Defectos removidos por fase`
  String get titleDefectsRemovedByPhase {
    return Intl.message(
      'Defectos removidos por fase',
      name: 'titleDefectsRemovedByPhase',
      desc: '',
      args: [],
    );
  }

  /// `Tamaños de los programas`
  String get titleSizeOfPrograms {
    return Intl.message(
      'Tamaños de los programas',
      name: 'titleSizeOfPrograms',
      desc: '',
      args: [],
    );
  }

  /// `Total de defectos`
  String get titleTotalDefects {
    return Intl.message(
      'Total de defectos',
      name: 'titleTotalDefects',
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

  /// `Despidiendo`
  String get progressDialogFiring {
    return Intl.message(
      'Despidiendo',
      name: 'progressDialogFiring',
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

  /// `Error interno del servidor`
  String get message500 {
    return Intl.message(
      'Error interno del servidor',
      name: 'message500',
      desc: '',
      args: [],
    );
  }

  /// `Ocurrió un error inesperado, inténtelo nuevamente`
  String get messageUnexpectedError {
    return Intl.message(
      'Ocurrió un error inesperado, inténtelo nuevamente',
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

  /// `Excedió el número máximo de intentos de sesión por hora`
  String get messageExceededMaximumNumberSessionAttempts {
    return Intl.message(
      'Excedió el número máximo de intentos de sesión por hora',
      name: 'messageExceededMaximumNumberSessionAttempts',
      desc: '',
      args: [],
    );
  }

  /// `¡Te hemos enviado un email!`
  String get messageWeHaveSentEmail {
    return Intl.message(
      '¡Te hemos enviado un email!',
      name: 'messageWeHaveSentEmail',
      desc: '',
      args: [],
    );
  }

  /// `¡Te hemos enviado un SMS!`
  String get messageWeHaveSentSMS {
    return Intl.message(
      '¡Te hemos enviado un SMS!',
      name: 'messageWeHaveSentSMS',
      desc: '',
      args: [],
    );
  }

  /// `La solicitud ha tardado mucho, inténtelo nuevamente`
  String get messageTimeOutException {
    return Intl.message(
      'La solicitud ha tardado mucho, inténtelo nuevamente',
      name: 'messageTimeOutException',
      desc: '',
      args: [],
    );
  }

  /// `Se require al menos un usuario`
  String get messageAtLeastOneUserIsRequiered {
    return Intl.message(
      'Se require al menos un usuario',
      name: 'messageAtLeastOneUserIsRequiered',
      desc: '',
      args: [],
    );
  }

  /// `Se require al menos un lenguaje`
  String get messageAtLeastOneLanguageIsRequiered {
    return Intl.message(
      'Se require al menos un lenguaje',
      name: 'messageAtLeastOneLanguageIsRequiered',
      desc: '',
      args: [],
    );
  }

  /// `Se require al menos un lenguaje y un usuario`
  String get messageAtLeastOneUserAndLanguageIsRequiered {
    return Intl.message(
      'Se require al menos un lenguaje y un usuario',
      name: 'messageAtLeastOneUserAndLanguageIsRequiered',
      desc: '',
      args: [],
    );
  }

  /// `No puede haber una diferencia negativa entre fechas`
  String get messageNoNegativeDifferenceBetweenDates {
    return Intl.message(
      'No puede haber una diferencia negativa entre fechas',
      name: 'messageNoNegativeDifferenceBetweenDates',
      desc: '',
      args: [],
    );
  }

  /// `El correo electrónico ya se encuentra en uso`
  String get messageEmailIsAlreadyInUse {
    return Intl.message(
      'El correo electrónico ya se encuentra en uso',
      name: 'messageEmailIsAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `El teléfono ya se encuentra en uso`
  String get messagePhoneIsAlreadyInUse {
    return Intl.message(
      'El teléfono ya se encuentra en uso',
      name: 'messagePhoneIsAlreadyInUse',
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

  /// `Debe tener al menos 3 carateres`
  String get inputNameError {
    return Intl.message(
      'Debe tener al menos 3 carateres',
      name: 'inputNameError',
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

  /// `Número inválido`
  String get inputPhoneError {
    return Intl.message(
      'Número inválido',
      name: 'inputPhoneError',
      desc: '',
      args: [],
    );
  }

  /// `Nombre`
  String get labelName {
    return Intl.message(
      'Nombre',
      name: 'labelName',
      desc: '',
      args: [],
    );
  }

  /// `Descripción`
  String get labelDescription {
    return Intl.message(
      'Descripción',
      name: 'labelDescription',
      desc: '',
      args: [],
    );
  }

  /// `Fecha de planeación`
  String get labelPlanningDate {
    return Intl.message(
      'Fecha de planeación',
      name: 'labelPlanningDate',
      desc: '',
      args: [],
    );
  }

  /// `Fecha de inicio`
  String get labelStartDate {
    return Intl.message(
      'Fecha de inicio',
      name: 'labelStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Fecha de finalización`
  String get labelFinishDate {
    return Intl.message(
      'Fecha de finalización',
      name: 'labelFinishDate',
      desc: '',
      args: [],
    );
  }

  /// `Fecha de actualización`
  String get labelUpdateDate {
    return Intl.message(
      'Fecha de actualización',
      name: 'labelUpdateDate',
      desc: '',
      args: [],
    );
  }

  /// `Fecha de entrega`
  String get labelDeliveryDate {
    return Intl.message(
      'Fecha de entrega',
      name: 'labelDeliveryDate',
      desc: '',
      args: [],
    );
  }

  /// `Lenguaje del sistema`
  String get labelSystemLanguage {
    return Intl.message(
      'Lenguaje del sistema',
      name: 'labelSystemLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Teléfono`
  String get labelPhone {
    return Intl.message(
      'Teléfono',
      name: 'labelPhone',
      desc: '',
      args: [],
    );
  }

  /// `Apellido`
  String get labelLastName {
    return Intl.message(
      'Apellido',
      name: 'labelLastName',
      desc: '',
      args: [],
    );
  }

  /// `Usuario: `
  String get labelUser {
    return Intl.message(
      'Usuario: ',
      name: 'labelUser',
      desc: '',
      args: [],
    );
  }

  /// `Lenguaje`
  String get labelLanguage {
    return Intl.message(
      'Lenguaje',
      name: 'labelLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Lineas planeadas:`
  String get labelPlannedLines {
    return Intl.message(
      'Lineas planeadas:',
      name: 'labelPlannedLines',
      desc: '',
      args: [],
    );
  }

  /// `Lineas base planeadas:`
  String get labelPlannedBaseLines {
    return Intl.message(
      'Lineas base planeadas:',
      name: 'labelPlannedBaseLines',
      desc: '',
      args: [],
    );
  }

  /// `Líneas:`
  String get labelLines {
    return Intl.message(
      'Líneas:',
      name: 'labelLines',
      desc: '',
      args: [],
    );
  }

  /// `Número:`
  String get labelNumber {
    return Intl.message(
      'Número:',
      name: 'labelNumber',
      desc: '',
      args: [],
    );
  }

  /// `Líneas planeadas`
  String get labeLinesPlanned {
    return Intl.message(
      'Líneas planeadas',
      name: 'labeLinesPlanned',
      desc: '',
      args: [],
    );
  }

  /// `Líneas actuales`
  String get labeLinesCurrent {
    return Intl.message(
      'Líneas actuales',
      name: 'labeLinesCurrent',
      desc: '',
      args: [],
    );
  }

  /// `Líneas base: `
  String get labeLinesBase {
    return Intl.message(
      'Líneas base: ',
      name: 'labeLinesBase',
      desc: '',
      args: [],
    );
  }

  /// `Líneas borradas: `
  String get labeLinesDeleted {
    return Intl.message(
      'Líneas borradas: ',
      name: 'labeLinesDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Líneas editadas: `
  String get labeLinesEdits {
    return Intl.message(
      'Líneas editadas: ',
      name: 'labeLinesEdits',
      desc: '',
      args: [],
    );
  }

  /// `Líneas añadidas: `
  String get labeLinesAdded {
    return Intl.message(
      'Líneas añadidas: ',
      name: 'labeLinesAdded',
      desc: '',
      args: [],
    );
  }

  /// `Programa Base: `
  String get labelBaseProgram {
    return Intl.message(
      'Programa Base: ',
      name: 'labelBaseProgram',
      desc: '',
      args: [],
    );
  }

  /// `No se pudo cargar el nombre del programa base, intenta recargando los programas.`
  String get labelCanNotLoadProgramBaseName {
    return Intl.message(
      'No se pudo cargar el nombre del programa base, intenta recargando los programas.',
      name: 'labelCanNotLoadProgramBaseName',
      desc: '',
      args: [],
    );
  }

  /// `Type: `
  String get labelType {
    return Intl.message(
      'Type: ',
      name: 'labelType',
      desc: '',
      args: [],
    );
  }

  /// `Size: `
  String get labelSize {
    return Intl.message(
      'Size: ',
      name: 'labelSize',
      desc: '',
      args: [],
    );
  }

  /// `Métodos planeados`
  String get labeMethodsPlanned {
    return Intl.message(
      'Métodos planeados',
      name: 'labeMethodsPlanned',
      desc: '',
      args: [],
    );
  }

  /// `Métodos actuales`
  String get labeMethodsCurrent {
    return Intl.message(
      'Métodos actuales',
      name: 'labeMethodsCurrent',
      desc: '',
      args: [],
    );
  }

  /// `Programa Reutilizable: `
  String get labelReusableProgram {
    return Intl.message(
      'Programa Reutilizable: ',
      name: 'labelReusableProgram',
      desc: '',
      args: [],
    );
  }

  /// `ID del defecto que lo desencadenó`
  String get labelIdChainedDefectLog {
    return Intl.message(
      'ID del defecto que lo desencadenó',
      name: 'labelIdChainedDefectLog',
      desc: '',
      args: [],
    );
  }

  /// `Añadido en`
  String get labelPhaseAdded {
    return Intl.message(
      'Añadido en',
      name: 'labelPhaseAdded',
      desc: '',
      args: [],
    );
  }

  /// `Removido en`
  String get labelPhaseRemoved {
    return Intl.message(
      'Removido en',
      name: 'labelPhaseRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Defecto estándar`
  String get labelStandardDefect {
    return Intl.message(
      'Defecto estándar',
      name: 'labelStandardDefect',
      desc: '',
      args: [],
    );
  }

  /// `No aplica`
  String get labelNone {
    return Intl.message(
      'No aplica',
      name: 'labelNone',
      desc: '',
      args: [],
    );
  }

  /// `Solución`
  String get labelSolution {
    return Intl.message(
      'Solución',
      name: 'labelSolution',
      desc: '',
      args: [],
    );
  }

  /// `Tiempo en reparar`
  String get labelTimeForRepair {
    return Intl.message(
      'Tiempo en reparar',
      name: 'labelTimeForRepair',
      desc: '',
      args: [],
    );
  }

  /// `Fase`
  String get labelPhase {
    return Intl.message(
      'Fase',
      name: 'labelPhase',
      desc: '',
      args: [],
    );
  }

  /// `Tiempo Delta`
  String get labelDeltaTime {
    return Intl.message(
      'Tiempo Delta',
      name: 'labelDeltaTime',
      desc: '',
      args: [],
    );
  }

  /// `Comentarios`
  String get labelComments {
    return Intl.message(
      'Comentarios',
      name: 'labelComments',
      desc: '',
      args: [],
    );
  }

  /// `Número del test`
  String get labelTestNumber {
    return Intl.message(
      'Número del test',
      name: 'labelTestNumber',
      desc: '',
      args: [],
    );
  }

  /// `Condiciones`
  String get labelConditions {
    return Intl.message(
      'Condiciones',
      name: 'labelConditions',
      desc: '',
      args: [],
    );
  }

  /// `Resultado esperado`
  String get labelExpectedResult {
    return Intl.message(
      'Resultado esperado',
      name: 'labelExpectedResult',
      desc: '',
      args: [],
    );
  }

  /// `Resultado actual`
  String get labelCurrentResult {
    return Intl.message(
      'Resultado actual',
      name: 'labelCurrentResult',
      desc: '',
      args: [],
    );
  }

  /// `Objetivo`
  String get labelObjective {
    return Intl.message(
      'Objetivo',
      name: 'labelObjective',
      desc: '',
      args: [],
    );
  }

  /// `Recuperar contraseña mediante email`
  String get labelRestorePasswordByEmail {
    return Intl.message(
      'Recuperar contraseña mediante email',
      name: 'labelRestorePasswordByEmail',
      desc: '',
      args: [],
    );
  }

  /// `Recuperar contraseña mediante número telefónico`
  String get labelRestorePasswordByPhoneNumber {
    return Intl.message(
      'Recuperar contraseña mediante número telefónico',
      name: 'labelRestorePasswordByPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Recuperar contraseña`
  String get labelRestorePassword {
    return Intl.message(
      'Recuperar contraseña',
      name: 'labelRestorePassword',
      desc: '',
      args: [],
    );
  }

  /// `Cambiar contraseña`
  String get labelChangePassword {
    return Intl.message(
      'Cambiar contraseña',
      name: 'labelChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `Posiciones`
  String get labelPositions {
    return Intl.message(
      'Posiciones',
      name: 'labelPositions',
      desc: '',
      args: [],
    );
  }

  /// `Organización`
  String get labelOrganization {
    return Intl.message(
      'Organización',
      name: 'labelOrganization',
      desc: '',
      args: [],
    );
  }

  /// `Años en general`
  String get labelYearsGenerals {
    return Intl.message(
      'Años en general',
      name: 'labelYearsGenerals',
      desc: '',
      args: [],
    );
  }

  /// `Años en configuración`
  String get labelYearsConfiguration {
    return Intl.message(
      'Años en configuración',
      name: 'labelYearsConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `Años en integración`
  String get labelYearsIntegration {
    return Intl.message(
      'Años en integración',
      name: 'labelYearsIntegration',
      desc: '',
      args: [],
    );
  }

  /// `Años en requerimientos`
  String get labelYearsRequirements {
    return Intl.message(
      'Años en requerimientos',
      name: 'labelYearsRequirements',
      desc: '',
      args: [],
    );
  }

  /// `Años en diseño`
  String get labelYearsDesign {
    return Intl.message(
      'Años en diseño',
      name: 'labelYearsDesign',
      desc: '',
      args: [],
    );
  }

  /// `Años en tests`
  String get labelYearsTests {
    return Intl.message(
      'Años en tests',
      name: 'labelYearsTests',
      desc: '',
      args: [],
    );
  }

  /// `Años en soporte`
  String get labelYearsSupport {
    return Intl.message(
      'Años en soporte',
      name: 'labelYearsSupport',
      desc: '',
      args: [],
    );
  }

  /// `Cargando...`
  String get labelLoading {
    return Intl.message(
      'Cargando...',
      name: 'labelLoading',
      desc: '',
      args: [],
    );
  }

  /// `No disponible`
  String get labelNotAvailable {
    return Intl.message(
      'No disponible',
      name: 'labelNotAvailable',
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

  /// `Despedir`
  String get buttonFireUser {
    return Intl.message(
      'Despedir',
      name: 'buttonFireUser',
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

  /// `¿Es administrador?`
  String get titleIsAdmin {
    return Intl.message(
      '¿Es administrador?',
      name: 'titleIsAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Modo oscuro`
  String get darkMode {
    return Intl.message(
      'Modo oscuro',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Modo claro`
  String get lightMode {
    return Intl.message(
      'Modo claro',
      name: 'lightMode',
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
      Locale.fromSubtags(languageCode: 'en'),
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