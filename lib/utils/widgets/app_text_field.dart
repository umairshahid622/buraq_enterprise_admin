import 'package:buraq_enterprise_admin/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  final TextFieldType type;
  final TextEditingController controller;
  final bool? autoFocus;
  final String? labelText;
  final bool? obscureText;
  final bool readOnly;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final String? hintText;
  final TextAlign? textAlign;
  final double? borderRadius;
  final int? maxLength;
  final String? counterText;
  final FontWeight? fontWeight;
  final FocusNode? focusNode;
  final Function(String value)? onTextChangeCallBack;
  final Function()? onTapCallBack;

  const AppTextField({
    super.key,
    this.type = TextFieldType.text,
    required this.controller,
    this.labelText,
    this.hintText,

    this.obscureText,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTextChangeCallBack,
    this.onTapCallBack,
    this.autoFocus,
    this.paddingHorizontal,
    this.paddingVertical,
    this.textAlign,
    this.borderRadius,
    this.maxLength,
    this.counterText,
    this.fontWeight,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final TextInputType keyBoardType;
    final Widget? defaultPrefixIcon;

    switch (type) {
      case TextFieldType.email:
        keyBoardType = TextInputType.emailAddress;
        defaultPrefixIcon = null;
        break;
      case TextFieldType.otp || TextFieldType.amount:
        keyBoardType = TextInputType.number;
        defaultPrefixIcon = null;
        break;
      case TextFieldType.phoneNumber:
        keyBoardType = TextInputType.phone;
        defaultPrefixIcon = const Icon(Icons.phone);
        break;
      default:
        keyBoardType = TextInputType.text;
        defaultPrefixIcon = Icon(Icons.edit_note_rounded);
        break;
    }


    final FocusNode focus = focusNode ?? FocusNode();


    return Obx(() {
      final AppColorScheme appColorScheme = context.appColors;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null) Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.textFieldLabelMargin),
            child: AppTextHeading(text: labelText!, fontSize: 14),
          ),
          if (labelText != null) const SizedBox(height: 8),

          TextFormField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            readOnly: readOnly,
            onTap: onTapCallBack ?? () {},
            showCursor: !focus.hasFocus,
            textAlign: textAlign ?? TextAlign.start,
            autofocus: autoFocus ?? false,
            maxLength: maxLength,
            focusNode: focusNode,

            obscureText: type == TextFieldType.password
                ? (obscureText ?? true)
                : false,

            controller: controller,

            keyboardType: keyBoardType,
            onChanged: onTextChangeCallBack,
            validator: (value) {
              if (type == TextFieldType.phoneNumber) {
                return AppUtils.phoneNumberValidator(value: value ?? "");
              } else if (type == TextFieldType.text) {
                return AppUtils.textValidator(value: value ?? "");
              } else if (type == TextFieldType.amount){
                return AppUtils.amountValidator(value: int.tryParse(value ?? ""));
              } else {
                return null;
              }
            },
            style: GoogleFonts.inter(
              fontWeight: fontWeight ?? FontWeight.normal,
            ),
            decoration: InputDecoration(
              filled: true,
              hintText: hintText,
              prefixIcon: prefixIcon ?? defaultPrefixIcon,
              suffixIcon: suffixIcon,
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppConstants.borderRadius,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppConstants.borderRadius,
                ),
                borderSide: BorderSide(color: appColorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppConstants.borderRadius,
                ),
                borderSide: BorderSide(color: appColorScheme.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppConstants.borderRadius,
                ),
                borderSide: BorderSide(
                  color: appColorScheme.error.withValues(alpha: .4),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppConstants.borderRadius,
                ),
                borderSide: BorderSide(
                  color: appColorScheme.error.withValues(alpha: .4),
                  width: 2,
                ),
              ),
              prefixIconColor: WidgetStateColor.resolveWith((state) {
                if (state.contains(WidgetState.error)) {
                  return appColorScheme.error;
                }
                return appColorScheme.text;
              }),
              contentPadding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal ?? 16,
                vertical: paddingVertical ?? 14,
              ),
              hintStyle: WidgetStateTextStyle.resolveWith((states) {
                if (states.contains(WidgetState.error)) {
                  return GoogleFonts.inter(color: appColorScheme.error);
                }
                return GoogleFonts.inter(color: appColorScheme.secondary);
              }),
            ),
          ),
        ],
      );
    });
  }
}
