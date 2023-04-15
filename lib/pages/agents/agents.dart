import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_admin/constants/app_colors.dart';
import 'package:web_admin/constants/app_styles.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/models/agent_data.dart';
import 'package:web_admin/pages/agents/agents_view_model.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/widgets/app_button.dart';

class Agents extends StatefulWidget {
  const Agents({Key? key}) : super(key: key);

  @override
  State<Agents> createState() => _AgentsState();
}

class _AgentsState extends State<Agents> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> sortList = ['Name', 'Date created', 'Active', 'Email'];
  String? selectedSorting = 'Name';

  @override
  Widget build(BuildContext context) => BaseView<AdminsViewModel>(
    onModelReady: (model) => model.loadAgents(),
    builder: (_, model, __) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Agents', style: titleStyle,),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: 300,
                    height: 47,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2, color: unfocusedColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppButton(
                    text: 'Create Agent',
                    onPressed: () async {
                      bool? res = await WebRoute.dashboardGo(WebRoute.agentCreate);
                      if (res == true) {
                        model.loadAgents();
                      }
                    },
                  ),
                  const SizedBox(height: 10,),
                  Card(
                    child: Container(
                      height: 45,
                      width: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sort by'),
                          Container(width: 2, height: 30, color: unfocusedColor,),
                          DropdownButton<String>(
                            value: selectedSorting,
                            underline: Container(),
                            items: sortList.map((e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            )).toList(),
                            onChanged: (s) {
                              setState(() {
                                selectedSorting = s;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Expanded(child: model.agents.isNotEmpty ? GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: model.agents.map((e) => adminCard(model, e)).toList(),
          ): const Center(child: Text('Click on the "Create Agent" button to create new agents.'),)),
        ],
      ),
    ),
  );

  Widget adminCard(AdminsViewModel model, AgentData data) => Card(
    child: Container(
      height: 400,
      width: 337,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 25,
                width: 70,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                color: data.status == 'active' ? creditBackgroundColor : debitBackgroundColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: data.status == 'active' ? creditColor : debitColor,
                      ),
                    ),
                    const Spacer(),
                    Text('${data.status}', style: TextStyle(color: data.status == 'active' ? creditColor : debitColor),)
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                onSelected: (AdminMenu menu) async {
                  switch (menu) {
                    case AdminMenu.edit:
                      await WebRoute.dashboardGo(WebRoute.agentEdit, arguments: data);
                      model.loadAgents();
                      break;
                    case AdminMenu.block:
                      await model.blockAgent(data);
                      model.loadAgents();
                      break;
                  }
                },
                itemBuilder: (BuildContext ctx) => <PopupMenuEntry<AdminMenu>>[
                  PopupMenuItem(
                    value: AdminMenu.edit,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.edit, size: 15,),
                        SizedBox(width: 5,),
                        Text('Edit')
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: AdminMenu.block,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.block, size: 15,),
                        SizedBox(width: 5,),
                        Text('Block')
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5,),
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: unfocusedColor
            ),
            child: const Icon(Icons.person, size: 70,),
          ),
          Text('${data.firstName} ${data.lastName}', style: subtitleStyle,),
          const Text('Access code: ******', style: normalBlackStyle,),
          Text('${data.phoneNumber}', style: normalFaintStyle,),
          Text('${data.email}', style: normalFaintStyle,),
          const SizedBox(height: 10,),
          Container(
            height: 2,
            width: 200,
            color: unfocusedColor,
          ),
          const SizedBox(height: 10,),
          Container(
            height: 30,
            width: 114,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: unfocusedColor
            ),
            child: const Center(child: Text('Role: Admin', style: normalFaintStyle,)),
          ),
        ],
      ),
    ),
  );
}