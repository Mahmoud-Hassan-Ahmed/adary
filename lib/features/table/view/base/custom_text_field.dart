import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:adary/core/conts/app_text_styles.dart';
import '../../utils/app_colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/style.dart';

class CustomTextField extends StatefulWidget {
  final String titleText;
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isPassword;
  final bool hintColored;
  final Function? onChanged;
  final Function? onSubmit;
  final bool isEnabled;
  final int maxLines;
  final TextCapitalization capitalization;
  final String? prefixImage;
  final IconData? prefixIcon;
  final double prefixSize;

  final String? Function(String?)? validate;
  final TextAlign textAlign;
  final bool isAmount;
  final bool isNumber;
  final bool showTitle;
  final bool showBorder;
  final double iconSize;
  final bool divider;
  final bool isPhone;
  final String? countryDialCode;

  const CustomTextField({
    Key? key,
    this.titleText = 'Write something...',
    this.hintText = '',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.validate,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSubmit,
    this.onChanged,
    this.prefixImage,
    this.hintColored = false,
    this.prefixIcon,
    this.capitalization = TextCapitalization.none,
    this.isPassword = false,
    this.prefixSize = Dimensions.PADDING_SIZE_SMALL,
    this.textAlign = TextAlign.start,
    this.isAmount = false,
    this.isNumber = false,
    this.showTitle = false,
    this.showBorder = true,
    this.iconSize = 18,
    this.divider = false,
    this.isPhone = false,
    this.countryDialCode,
  }) : super(key: key);

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.showTitle
            ? Text(widget.titleText,
                style: MerriweatherRegular.copyWith(
                    fontSize: AppTextStyles.caption,             // 12sp — field title label
                    color: widget.hintColored ? Colors.red : null))
            : const SizedBox(),
        SizedBox(
            height: widget.showTitle ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
        TextFormField(
          maxLines: widget.maxLines,
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: widget.textAlign,
          style: MerriweatherRegular.copyWith(
              fontSize: AppTextStyles.subtitle1),               // 16sp — input text
          textInputAction: widget.inputAction,
          keyboardType:
              widget.isAmount ? TextInputType.number : widget.inputType,
          cursorColor: AppColors.GREYFONTCOLOR,
          textCapitalization: widget.capitalization,
          enabled: widget.isEnabled,
          autofocus: false,
          obscureText: widget.isPassword ? _obscureText : false,
          inputFormatters: widget.inputType == TextInputType.phone
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ]
              : widget.isAmount
                  ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                  : widget.isNumber
                      ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))]
                      : null,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
              borderSide: BorderSide(
                  style:
                      widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                  width: 0.4,
                  color: AppColors.BORDERGREYCOLOR),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
              borderSide: BorderSide(
                  style:
                      widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                  width: 0.6,
                  color: AppColors.BORDERGREYCOLOR.withOpacity(0.8)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
              borderSide: BorderSide(
                  style:
                      widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                  width: 0.3,
                  color: Theme.of(context).primaryColor),
            ),
            isDense: true,
            hintText:
                widget.hintText.isEmpty ? widget.titleText : widget.hintText,
            fillColor: Theme.of(context).cardColor,
            hintStyle: AlMaraiaRegular.copyWith(
                fontSize: AppTextStyles.bodySm,                // 14sp — hint text
                color: Theme.of(context).hintColor),
            filled: true,
            prefixIcon: widget.isPhone
                ? SizedBox(
                    width: 95,
                    child: Row(children: [
                      Container(
                          width: 85,
                          height: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.RADIUS_SMALL),
                              bottomLeft:
                                  Radius.circular(Dimensions.RADIUS_SMALL),
                            ),
                          ),
                          margin: const EdgeInsets.only(right: 0),
                          padding: const EdgeInsets.only(left: 5),
                          child: Container()),
                      Container(
                        height: 20,
                        width: 2,
                        color: Theme.of(context).disabledColor,
                      )
                    ]),
                  )
                : widget.prefixImage != null && widget.prefixIcon == null
                    ? Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: widget.prefixSize),
                        child: Image.asset(widget.prefixImage!,
                            height: 20, width: 20),
                      )
                    : widget.prefixImage == null && widget.prefixIcon != null
                        ? Icon(widget.prefixIcon, size: widget.iconSize)
                        : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).hintColor.withOpacity(0.3)),
                    onPressed: _toggle,
                  )
                : null,
          ),
          validator: widget.validate,
          onChanged: widget.onChanged as void Function(String)?,
        ),
        widget.divider
            ? const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_LARGE),
                child: Divider())
            : const SizedBox(),
      ],
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}














//
//
//
//
// import 'package:efood_multivendor/util/dimensions.dart';
// import 'package:efood_multivendor/util/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class CustomTextField extends StatefulWidget {
//   final String hintText;
//   final TextEditingController? controller;
//   final FocusNode? focusNode;
//   final FocusNode? nextFocus;
//   final TextInputType inputType;
//   final TextInputAction inputAction;
//   final bool isPassword;
//   final Function? onChanged;
//   final Function? onSubmit;
//   final bool isEnabled;
//   final int maxLines;
//   final TextCapitalization capitalization;
//   final String? prefixIcon;
//   final double prefixSize;
//   final bool divider;
//   final TextAlign textAlign;
//   final bool isAmount;
//   final bool isNumber;
//   final bool showTitle;
//   final Color? fillColor;
//
//   const CustomTextField(
//       {Key? key, this.hintText = 'Write something...',
//       this.controller,
//       this.focusNode,
//       this.nextFocus,
//       this.isEnabled = true,
//       this.inputType = TextInputType.text,
//       this.inputAction = TextInputAction.next,
//       this.maxLines = 1,
//       this.onSubmit,
//       this.onChanged,
//       this.prefixIcon,
//       this.capitalization = TextCapitalization.none,
//       this.isPassword = false,
//       this.prefixSize = Dimensions.paddingSizeSmall,
//       this.divider = false,
//       this.textAlign = TextAlign.start,
//       this.isAmount = false,
//       this.isNumber = false,
//       this.showTitle = false,
//       this.fillColor,
//       }) : super(key: key);
//
//   @override
//   CustomTextFieldState createState() => CustomTextFieldState();
// }
//
// class CustomTextFieldState extends State<CustomTextField> {
//   bool _obscureText = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         widget.showTitle ? Text(widget.hintText, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)) : const SizedBox(),
//         SizedBox(height: widget.showTitle ? Dimensions.paddingSizeExtraSmall : 0),
//
//         TextField(
//           maxLines: widget.maxLines,
//           controller: widget.controller,
//           focusNode: widget.focusNode,
//           textAlign: widget.textAlign,
//           style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
//           textInputAction: widget.nextFocus == null ? TextInputAction.done : widget.inputAction,
//           keyboardType: widget.isAmount ? TextInputType.number : widget.inputType,
//           cursorColor: Theme.of(context).primaryColor,
//           textCapitalization: widget.capitalization,
//           enabled: widget.isEnabled,
//           autofocus: false,
//           obscureText: widget.isPassword ? _obscureText : false,
//           inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
//               : widget.isAmount ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))] : widget.isNumber ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))] : null,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//               borderSide: const BorderSide(style: BorderStyle.none, width: 0),
//             ),
//             isDense: true,
//             hintText: widget.hintText,
//             fillColor: widget.fillColor ?? Theme.of(context).cardColor,
//             hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor),
//             filled: true,
//             prefixIcon: widget.prefixIcon != null ? Padding(
//               padding: EdgeInsets.symmetric(horizontal: widget.prefixSize),
//               child: Image.asset(widget.prefixIcon!, height: 20, width: 20),
//             ) : null,
//             suffixIcon: widget.isPassword ? IconButton(
//               icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withOpacity(0.3)),
//               onPressed: _toggle,
//             ) : null,
//           ),
//           onSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus)
//               : widget.onSubmit != null ? widget.onSubmit!(text) : null,
//           onChanged: widget.onChanged as void Function(String)?,
//         ),
//
//         widget.divider ? const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge), child: Divider()) : const SizedBox(),
//       ],
//     );
//   }
//
//   void _toggle() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }
// }
