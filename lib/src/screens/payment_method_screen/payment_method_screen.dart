import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

enum PaymentMethodType {
  easypaisa,
  jazzCash,
  mastercard,
  visa,
  paypal,
  applePay,
  googlePay,
}

class PaymentMethodModel {
  final PaymentMethodType type;
  final String title;
  final String subtitle;
  final String assetPath;
  final Color backgroundColor;

  const PaymentMethodModel({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.backgroundColor,
  });
}

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({
    super.key,
  });

  @override
  State<PaymentMethodScreen> createState() {
    return _PaymentMethodScreenState();
  }
}

class _PaymentMethodScreenState
    extends State<PaymentMethodScreen> {
  static const Color primaryColor =
  Color(0xffF97316);

  PaymentMethodType selectedMethod =
      PaymentMethodType.easypaisa;

  final List<PaymentMethodModel> paymentMethods = const [
    PaymentMethodModel(
      type: PaymentMethodType.easypaisa,
      title: 'Easypaisa',
      subtitle: 'Pay with Easypaisa account',
      assetPath:
      'assets/payments_method_icon/easy_paisa.svg',
      backgroundColor: Color(0xffEAF9F0),
    ),
    PaymentMethodModel(
      type: PaymentMethodType.jazzCash,
      title: 'JazzCash',
      subtitle: 'Pay with JazzCash account',
      assetPath:
      'assets/payments_method_icon/JazzCash.svg',
      backgroundColor: Color(0xffFFF0F0),
    ),
    PaymentMethodModel(
      type: PaymentMethodType.mastercard,
      title: 'Mastercard',
      subtitle: '**** **** **** 4679',
      assetPath:
      'assets/payments_method_icon/master_card.svg',
      backgroundColor: Color(0xffFFF4EA),
    ),
    // PaymentMethodModel(
    //   type: PaymentMethodType.visa,
    //   title: 'Visa',
    //   subtitle: '**** **** **** 3274',
    //   assetPath:
    //   'assets/icons/payment_methods/visa.svg',
    //   backgroundColor: Color(0xffEEF3FF),
    // ),
    // PaymentMethodModel(
    //   type: PaymentMethodType.paypal,
    //   title: 'PayPal',
    //   subtitle: 'example@gmail.com',
    //   assetPath:
    //   'assets/icons/payment_methods/paypal.svg',
    //   backgroundColor: Color(0xffEEF5FF),
    // ),
    // PaymentMethodModel(
    //   type: PaymentMethodType.applePay,
    //   title: 'Apple Pay',
    //   subtitle: 'Connected',
    //   assetPath:
    //   'assets/icons/payment_methods/apple_pay.svg',
    //   backgroundColor: Color(0xffF2F2F2),
    // ),
    PaymentMethodModel(
      type: PaymentMethodType.googlePay,
      title: 'Google Pay',
      subtitle: 'Connected',
      assetPath:
      'assets/payments_method_icon/google_pay.svg',
      backgroundColor: Color(0xffF3F7FF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  20,
                  18,
                  20,
                ),
                itemCount: paymentMethods.length,
                separatorBuilder: (
                    BuildContext context,
                    int index,
                    ) {
                  return const SizedBox(height: 14);
                },
                itemBuilder: (
                    BuildContext context,
                    int index,
                    ) {
                  final PaymentMethodModel method =
                  paymentMethods[index];

                  return _buildPaymentMethodCard(
                    method,
                  );
                },
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 14,
          top: 8,
          bottom: 8,
        ),
        child: Material(
          color: Colors.white,
          shape: CircleBorder(
            side: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              Navigator.pop(context);
            },
            child: const SizedBox(
              width: 42,
              height: 42,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
      title: const Text(
        'Payment Methods',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
      PaymentMethodModel method,
      ) {
    final bool isSelected =
        selectedMethod == method.type;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          setState(() {
            selectedMethod = method.type;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 220,
          ),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? primaryColor
                  : Colors.grey.shade200,
              width: isSelected ? 1.6 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isSelected ? 0.06 : 0.025,
                ),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildPaymentLogo(method),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff151515),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      method.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildSelectionIndicator(
                isSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentLogo(
      PaymentMethodModel method,
      ) {
    return Container(
      width: 64,
      height: 56,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: method.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SvgPicture.asset(
        method.assetPath,
        fit: BoxFit.contain,
        placeholderBuilder: (
            BuildContext context,
            ) {
          return const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 1.8,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectionIndicator(
      bool isSelected,
      ) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 220,
      ),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor
            : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? primaryColor
              : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: isSelected
          ? const Icon(
        Icons.check_rounded,
        size: 16,
        color: Colors.white,
      )
          : null,
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: _showAddPaymentMethodSheet,
              icon: const Icon(
                Iconsax.add,
                size: 21,
              ),
              label: const Text(
                'Add New Payment Method',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(
                  color: primaryColor,
                  width: 1.3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _continuePayment,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _continueButtonText(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _continueButtonText() {
    switch (selectedMethod) {
      case PaymentMethodType.easypaisa:
        return 'Continue with Easypaisa';

      case PaymentMethodType.jazzCash:
        return 'Continue with JazzCash';

      case PaymentMethodType.mastercard:
        return 'Continue with Mastercard';

      case PaymentMethodType.visa:
        return 'Continue with Visa';

      case PaymentMethodType.paypal:
        return 'Continue with PayPal';

      case PaymentMethodType.applePay:
        return 'Continue with Apple Pay';

      case PaymentMethodType.googlePay:
        return 'Continue with Google Pay';
    }
  }

  void _continuePayment() {
    final PaymentMethodModel selected =
    paymentMethods.firstWhere(
          (PaymentMethodModel method) {
        return method.type == selectedMethod;
      },
    );

    debugPrint(
      'Selected payment method: ${selected.title}',
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${selected.title} selected',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: primaryColor,
        ),
      );

    // Payment gateway integration:
    //
    // switch (selected.type) {
    //   case PaymentMethodType.easypaisa:
    //     await paymentProvider.payWithEasypaisa();
    //     break;
    //
    //   case PaymentMethodType.jazzCash:
    //     await paymentProvider.payWithJazzCash();
    //     break;
    //
    //   default:
    //     break;
    // }
  }

  void _showAddPaymentMethodSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (
          BuildContext sheetContext,
          ) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              0,
              18,
              22,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Payment Method',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                _buildSheetMethod(
                  context: sheetContext,
                  title: 'Add debit or credit card',
                  subtitle:
                  'Visa or Mastercard supported',
                  icon: Iconsax.card,
                ),
                const SizedBox(height: 10),
                _buildSheetMethod(
                  context: sheetContext,
                  title: 'Connect Easypaisa',
                  subtitle:
                  'Use your Easypaisa mobile account',
                  assetPath:
                  'assets/icons/payment_methods/easypaisa.svg',
                ),
                const SizedBox(height: 10),
                _buildSheetMethod(
                  context: sheetContext,
                  title: 'Connect JazzCash',
                  subtitle:
                  'Use your JazzCash mobile account',
                  assetPath:
                  'assets/icons/payment_methods/jazzcash.svg',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetMethod({
    required BuildContext context,
    required String title,
    required String subtitle,
    IconData? icon,
    String? assetPath,
  }) {
    return Material(
      color: const Color(0xffF7F7F8),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: assetPath != null
                    ? SvgPicture.asset(
                  assetPath,
                  fit: BoxFit.contain,
                )
                    : Icon(
                  icon,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                        Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}