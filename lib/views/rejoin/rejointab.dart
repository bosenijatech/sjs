import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/views/leave/leavehistory.dart';
import 'package:winstar/views/rejoin/viewrejoin.dart';

class ReJoinTab extends StatefulWidget {
  const ReJoinTab({super.key});

  @override
  State<ReJoinTab> createState() => _ReJoinTabState();
}

class _ReJoinTabState extends State<ReJoinTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentindex = 0;
  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, vsync: this, length: 2);
    super.initState();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          currentindex = _tabController.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: AppUtils.buildNormalText(
                text: "Duty Resumption ", fontSize: 20, color: Colors.black),
            bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.yellow,
                onTap: (var index) {
                  if (index == 0) {
                    currentindex = index;
                  } else if (index == 1) {
                    currentindex = index;
                  }
                  setState(() {});
                },
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: AppUtils.buildNormalText(
                          text: "Leave History",
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: AppUtils.buildNormalText(
                          text: "Rejoin History",
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              LeaveandHistoryPage(),
              ViewRejoin(),
            ],
          )),
    );
  }
}
