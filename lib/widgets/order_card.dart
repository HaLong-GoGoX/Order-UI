import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:order_ui/core/theme/app_theme.dart';
import 'package:order_ui/gen/assets.gen.dart';
import 'package:order_ui/models/order.dart';
import 'package:order_ui/utils/date_time_formatter.dart';
import 'package:order_ui/utils/formatters.dart';
import 'package:order_ui/utils/order_status_helper.dart';
import 'package:order_ui/widgets/status_label.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderStatusHelper = Modular.get<OrderStatusHelper>();

    return InkWell(
      onTap: () => _navigateToDetailPage(context, order.id),
      child: Card(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0),
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 24.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            children: [
              IdAndStatus(id: "#${order.id.toString()}", statusCd: order.statusCd),
              SizedBox(height: 12.0),
              AmountTotal(number: order.total ?? 0),
              SizedBox(height: 12.0),
              DetailDateAndVehicle(
                dateOrder: DateTimeFormatter.formatDateTime(order.appointmentAt),
                vehicle: order.vehiclePool?.name ?? 'Unknown',
              ),
              SizedBox(height: 12.0),
              Address(
                appointmentPoint: order.fromPlace ?? 'Unknown',
                destinationPoint: order.toPlace ?? 'Unknown',
              ),
              SizedBox(height: 12.0),
              ButtonInOrderItem(status: orderStatusHelper.getStatusText(context, order.statusCd ?? 0)),
            ],
          ),
        ),
      ),
    );
  }
}

void _navigateToDetailPage(BuildContext context, int id) {
  Modular.to.pushNamed('/order/status/$id');
}

class IconWithText extends StatelessWidget {
  const IconWithText({super.key, required this.iconAsset, this.color, required this.text});
  
  final String iconAsset;
  final Color? color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: IconSection(icon: iconAsset, color: color),
        ),
        SizedBox(width: 12.0,),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
      ],
    );
  }
}

class IdAndStatus extends StatelessWidget {
  const IdAndStatus({super.key, required this.id, required this.statusCd});

  final String id;
  final int? statusCd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(id, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 0.04)), SizedBox(width: 8.0), StatusLabel(status: statusCd)],
    );
  }
}

class AmountTotal extends StatelessWidget {
  const AmountTotal({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return IconWithText(iconAsset: Assets.icons.creditCard, color: context.appTheme.palette.neutral3, text: formatWon(number));
  }
}

class DetailDateAndVehicle extends StatelessWidget {
  const DetailDateAndVehicle({super.key, required this.dateOrder, required this.vehicle});

  final String dateOrder;
  final String vehicle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date Order', style: TextStyle(color: context.appTheme.palette.neutral3)),
            SizedBox(height: 4.0,),
            Text(dateOrder, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle', style: TextStyle(color: context.appTheme.palette.neutral3)),
            SizedBox(height: 4.0,),
            Text(vehicle, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

class IconSection extends StatelessWidget {
  const IconSection({super.key, required this.icon, this.color});

  final String icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      width: 20,
      height: 20,
    );
  }
}

class Address extends StatelessWidget {
  const Address({super.key, required this.appointmentPoint, required this.destinationPoint});

  final String appointmentPoint;
  final String destinationPoint;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight( 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              IconSection(icon: Assets.icons.departureIcon),
              Expanded(
                child: Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: context.appTheme.palette.neutral2,
                ),
              ),
              IconSection(icon: Assets.icons.point, color: context.appTheme.palette.danger),
            ],
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appointmentPoint),
                const SizedBox(height: 26),
                Text(destinationPoint),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key, required this.textButton, this.status});

  final String textButton;
  final String? status;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor:
              status == 'Completed'
                  ? Colors.transparent
                  : context.appTheme.palette.primary,
          side: BorderSide(color: context.appTheme.palette.primary, width: 1.0),
          elevation: 0,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: Text(
            textButton,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.04,
              color:
                  status == 'Completed'
                      ? context.appTheme.palette.primary
                      : Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonInOrderItem extends StatelessWidget {
  const ButtonInOrderItem({super.key, this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    if (status == 'Completed') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: ButtonSection(textButton: 'Reorder',),),
          SizedBox(width: 20.0,),
          Expanded(child: ButtonSection(textButton: 'Receipt', status: status,)),
        ],
      );
    }
    else {
      return ButtonSection(textButton: 'Tip driver');
    }
  }
}