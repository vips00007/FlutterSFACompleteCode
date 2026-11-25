import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/outlet.dart';
import '../../../routes/route_names.dart';

class TicketCard extends StatefulWidget {
  final Outlet outlet;
  final VoidCallback? onCheckIn;

  const TicketCard({
    super.key,
    required this.outlet,
    this.onCheckIn,
  });

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  bool _isExpanded = false;

  // Color palette matching Add Outlet theme & prototype redesign
  static const Color blueColor = Color(0xFF6A3FD6);
  static const Color blue50Color = Color(0xFFF0EBFC);
  static const Color inkColor = Color(0xFF17193F);
  static const Color slateColor = Color(0xFF6B6F93);
  static const Color lineColor = Color(0xFFDCDBEA);
  static const Color redColor = Color(0xFFD62839);

  void _onStartVisit() {
    if (widget.onCheckIn != null) {
      widget.onCheckIn!();
    } else {
      final outlet = widget.outlet;
      final bool hasLocation = (outlet.latitude != null &&
          outlet.longitude != null &&
          outlet.latitude != 0.0 &&
          outlet.longitude != 0.0);

      if (!hasLocation) {
        // First-Time Visit (Lat/Lng Not Available): Open Visit Check-In (HTML screen design)
        Get.toNamed(RoutesName.visit_check_in_view, arguments: outlet);
      } else {
        // Existing Visit (Lat/Lng Available): Open Visit Details screen
        Get.toNamed(RoutesName.visit_details_view, arguments: outlet);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final outlet = widget.outlet;
    final String rawName = outlet.firmName.isNotEmpty
        ? outlet.firmName
        : '${outlet.firstName} ${outlet.lastName}'.trim();
    final String name = rawName.isNotEmpty ? rawName : 'Not Available';

    final String areaPart = outlet.area?.isNotEmpty == true ? '${outlet.area}, ' : '';
    final String cityPart = outlet.city.isNotEmpty ? outlet.city : '';
    final String locationText = (areaPart.isNotEmpty || cityPart.isNotEmpty)
        ? '$areaPart$cityPart'
        : 'Not Available';

    final String id = outlet.mobileNumber.isNotEmpty
        ? outlet.mobileNumber
        : (outlet.id?.isNotEmpty == true ? outlet.id! : 'Not Available');
    final String outstanding = 'Not Available';

    final performanceList = [
      ['Tgt', '₹0'],
      ['Ach', '₹0'],
      ['Bal', '₹0'],
      ['AvgL3M', 'Not Available'],
      ['Cov', '0'],
      ['Prod', '0'],
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
          // 1. COMPACT HEADER (Store icon, Name & ID on left, Location on top-right)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store Icon Avatar
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

                // Name & ID Badge on Left
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: name == 'Not Available' ? 12.5 : 15.0,
                          fontWeight: name == 'Not Available' ? FontWeight.w500 : FontWeight.bold,
                          color: name == 'Not Available' ? redColor : inkColor,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Customer ID Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: id == 'Not Available' ? redColor.withValues(alpha: 0.1) : blue50Color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'ID: ',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: slateColor,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                id,
                                style: TextStyle(
                                  fontSize: id == 'Not Available' ? 9.5 : 11.0,
                                  fontWeight: id == 'Not Available' ? FontWeight.w500 : FontWeight.bold,
                                  color: id == 'Not Available' ? redColor : blueColor,
                                  letterSpacing: 0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Location on Top-Right
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: redColor,
                    ),
                    const SizedBox(width: 2),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: Text(
                        locationText,
                        style: TextStyle(
                          fontSize: locationText == 'Not Available' ? 10.5 : 11.5,
                          color: locationText == 'Not Available' ? redColor : slateColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. ALWAYS-VISIBLE ACTION BAR (View More / View Less Toggle on Left, Start Visit on Right)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // View More / View Less Toggle Button (Left)
                InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: blue50Color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isExpanded ? 'View Less' : 'View More',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: blueColor,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                // Compact Premium Gradient Start Visit Button (Right)
                InkWell(
                  onTap: _onStartVisit,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8A2BE2), Color(0xFF6A3FD6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6A3FD6).withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Color(0xFF6A3FD6),
                            size: 11,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Start Visit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. ANIMATED COLLAPSIBLE EXPANDED DETAILS SECTION
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            child: _isExpanded
                ? Column(
                    children: [
                      const Divider(height: 1, color: lineColor),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Outstanding & Last Order Summary
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Outstanding',
                                      style: TextStyle(fontSize: 10.5, color: slateColor),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      outstanding,
                                      style: TextStyle(
                                        fontSize: outstanding == 'Not Available' ? 11.0 : 15.0,
                                        fontWeight: outstanding == 'Not Available' ? FontWeight.w500 : FontWeight.w800,
                                        color: redColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: slateColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Last order: 12 days ago',
                                    style: TextStyle(fontSize: 11, color: slateColor, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

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
                            const SizedBox(height: 10),

                            // Performance Grid (2 rows of 3 items)
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAF9FE),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: lineColor),
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
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
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
