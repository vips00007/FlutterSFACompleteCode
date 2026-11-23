import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/outlet.dart';
import '../../../routes/route_names.dart';

class TicketCard extends StatelessWidget {
  final Outlet outlet;
  final VoidCallback? onCheckIn;

  const TicketCard({
    super.key,
    required this.outlet,
    this.onCheckIn,
  });

  // Color palette matching Add Outlet theme & prototype redesign
  static const Color blueColor = Color(0xFF6A3FD6);
  static const Color blue50Color = Color(0xFFF0EBFC);
  static const Color inkColor = Color(0xFF17193F);
  static const Color slateColor = Color(0xFF6B6F93);
  static const Color lineColor = Color(0xFFDCDBEA);
  static const Color redColor = Color(0xFFD62839);

  @override
  Widget build(BuildContext context) {
    final String rawName = outlet.firmName.isNotEmpty
        ? outlet.firmName
        : '${outlet.firstName} ${outlet.lastName}'.trim();
    final String name = rawName.isNotEmpty ? rawName : 'Not Available';

    final String areaPart = outlet.area?.isNotEmpty == true ? '${outlet.area}, ' : '';
    final String cityPart = outlet.city.isNotEmpty ? outlet.city : '';
    final String locationText = (areaPart.isNotEmpty || cityPart.isNotEmpty)
        ? '$areaPart$cityPart'
        : 'Not Available';

    final String id = outlet.mobileNumber.isNotEmpty ? outlet.mobileNumber : 'Not Available';
    final String outstanding = 'Not Available';

    final performanceList = [
      ['Tgt', '₹0'],
      ['Ach', '₹0'],
      ['Bal', '₹0'],
      ['AvgL3M', 'Not Available'],
      ['Cov', '0'],
      ['Prod', '0'],
    ];

    return GestureDetector(
      onTap: onCheckIn ??
          () {
            Get.toNamed(RoutesName.visit_details_view, arguments: outlet);
          },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(106, 63, 214, 0.06),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
            BoxShadow(
              color: Color.fromRGBO(23, 25, 63, 0.03),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Store Icon, Name/Location/Code, Outstanding
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store Icon Avatar (44x44 compact)
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: blue50Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    color: blueColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),

                // Name & Location Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: name == 'Not Available' ? 12.5 : 15.5,
                          fontWeight: name == 'Not Available' ? FontWeight.w500 : FontWeight.bold,
                          color: name == 'Not Available' ? redColor : inkColor,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: locationText == 'Not Available' ? redColor : slateColor,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              locationText,
                              style: TextStyle(
                                fontSize: locationText == 'Not Available' ? 10.5 : 12.0,
                                color: locationText == 'Not Available' ? redColor : slateColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: id == 'Not Available' ? redColor.withValues(alpha: 0.1) : blue50Color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          id,
                          style: TextStyle(
                            fontSize: id == 'Not Available' ? 9.5 : 11.0,
                            fontWeight: id == 'Not Available' ? FontWeight.w500 : FontWeight.bold,
                            color: id == 'Not Available' ? redColor : blueColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),

                // Outstanding Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Outstanding',
                      style: TextStyle(fontSize: 10.5, color: slateColor),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      outstanding,
                      style: TextStyle(
                        fontSize: outstanding == 'Not Available' ? 11.0 : 16.5,
                        fontWeight: outstanding == 'Not Available' ? FontWeight.w500 : FontWeight.w800,
                        color: redColor,
                      ),
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      'Last order 12d',
                      style: TextStyle(fontSize: 11, color: slateColor),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Info 3-Column Grid (Channel, Group, Class)
            Row(
              children: [
                Expanded(child: _buildInfoBox('Channel', 'General Trade')),
                const SizedBox(width: 6),
                Expanded(child: _buildInfoBox('Group', 'Reached W/S')),
                const SizedBox(width: 6),
                Expanded(child: _buildInfoBox('Class', 'General Trade')),
              ],
            ),
            const SizedBox(height: 8),

            // Performance Grid (2 rows of 3 items)
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: lineColor)),
              ),
              child: Column(
                children: [
                  // Row 1: Tgt, Ach, Bal
                  Row(
                    children: [
                      Expanded(child: _buildPerfCell(performanceList[0][0], performanceList[0][1], borderLeft: false)),
                      Expanded(child: _buildPerfCell(performanceList[1][0], performanceList[1][1])),
                      Expanded(child: _buildPerfCell(performanceList[2][0], performanceList[2][1], isNegative: performanceList[2][1].contains('-'))),
                    ],
                  ),
                  const Divider(height: 1, color: lineColor),
                  // Row 2: AvgL3M, Cov, Prod
                  Row(
                    children: [
                      Expanded(child: _buildPerfCell(performanceList[3][0], performanceList[3][1], borderLeft: false)),
                      Expanded(child: _buildPerfCell(performanceList[4][0], performanceList[4][1])),
                      Expanded(child: _buildPerfCell(performanceList[5][0], performanceList[5][1])),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      decoration: BoxDecoration(
        color: blue50Color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: blueColor,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: inkColor,
              height: 1.15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPerfCell(String label, String value, {bool borderLeft = true, bool isNegative = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      decoration: BoxDecoration(
        border: borderLeft
            ? const Border(left: BorderSide(color: lineColor))
            : null,
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: blueColor,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: value == 'Not Available' ? 10.0 : 12.5,
              fontWeight: value == 'Not Available' ? FontWeight.w400 : FontWeight.w600,
              color: isNegative ? redColor : (value == 'Not Available' ? redColor : inkColor),
            ),
          ),
        ],
      ),
    );
  }
}
