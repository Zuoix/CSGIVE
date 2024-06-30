import 'package:cs_give/app.dart';
import 'package:cs_give/core/constants/images.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/core/utils/extensions.dart';
import 'package:cs_give/models/church_data.dart';
import 'package:cs_give/screens/auth/sign_in_screen.dart';
import 'package:cs_give/screens/church_map_view.dart';
import 'package:cs_give/screens/dashboard/donation_screen.dart';
import 'package:cs_give/screens/map_view.dart';
import 'package:cs_give/services/location_service.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_scroll_view.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchCont = TextEditingController();

  List<Church> searchResult = [];
  bool searching = false;

  void performSearch() {
    searchResult = cachedChurches!
        .where(
            (e) => e.name.toLowerCase().contains(searchCont.text.toLowerCase()))
        .toList();

    setState(() {});
  }

  Church? selectedChurch;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        toolbarHeight: getHeaderSize(context),
        centerTitle: selectedChurch == null,
        backgroundColor: kSecondaryColor,
        flexibleSpace: Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.fromLTRB(20, 5, 20, 10),
          color: kSecondaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  if (selectedChurch != null)
                    Container(
                      decoration: boxDecorationWithRoundedCorners(
                        boxShape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            selectedChurch = null;
                          });
                        },
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      ),
                    ).paddingRight(20),
                  Text(
                    selectedChurch != null ? 'Back' : 'Search',
                    style: boldText(
                        weight: FontWeight.w600, size: 22, color: white),
                  )
                ],
              ),
              20.height,
              AppTextField(
                controller: searchCont,
                textFieldType: TextFieldType.OTHER,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                onChanged: (s) {
                  if (s.isEmpty) {
                    searching = false;
                  } else {
                    searching = true;
                  }

                  performSearch();
                },
                onFieldSubmitted: (s) {},
                decoration: inputDecoration(
                  context,
                  isSearch: true,
                  labelText: 'Search church, Pastor, non-profit Organization',
                ),
              ),
            ],
          ),
        ),
      ),
      body: AppScrollView(
        children: [
          /// Map View
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: MapView(
              churchList: selectedChurch != null
                  ? [selectedChurch!]
                  : cachedChurches ?? [],
              miniView: true,
            ),
          ),

          if (selectedChurch == null) ...{
            searchResults(),
            searchResultList(),
          } else ...{
            searchedView()
          }
        ],
      ),
    );
  }

  Widget searchedView() {
    return Column(
      children: [
        Text(
          selectedChurch!.name,
          style: boldText(weight: FontWeight.w600),
        ).paddingSymmetric(horizontal: 16).paddingBottom(10),
        SnapHelperWidget(
          initialData: 'Loading...',
          future: buildFullAddressFromLatLong(
              selectedChurch!.latitude, selectedChurch!.longitude),
          onSuccess: (data) {
            return InkWell(
              onTap: () {
                ChurchMapView(
                  churches: selectedChurch != null
                      ? [selectedChurch!]
                      : cachedChurches!,
                ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
              },
              child: Text(data, style: primaryText(size: 14))
                  .paddingSymmetric(horizontal: 16)
                  .paddingBottom(15),
            );
          },
        ),
        if (selectedChurch!.email.isNotEmpty)
          ListTile(
            onTap: () {
              launchMail(selectedChurch!.email);
            },
            leading: CircleAvatar(
              child: ic_message.iconImage(),
            ),
            title: Text(
              selectedChurch!.email,
              style: primaryText(size: 15),
            ),
          ),
        if (selectedChurch!.phone.isNotEmpty)
          ListTile(
            onTap: () {
              launchCall(selectedChurch!.email);
            },
            leading: CircleAvatar(
              child: ic_call.iconImage(),
            ),
            title: Text(
              selectedChurch!.phone,
              style: primaryText(size: 15),
            ),
          ),
        ListTile(
          onTap: () {
            checkIfLink(selectedChurch!.website);
          },
          leading: const CircleAvatar(
            child: Icon(
              Icons.link,
              color: kPrimaryColor,
            ),
          ),
          title: Text(
            selectedChurch!.website,
            style: primaryText(size: 15),
          ),
        ),
        if (selectedChurch!.fbHandle.isNotEmpty)
          ListTile(
            onTap: () {
              checkIfLink(selectedChurch!.fbHandle);
            },
            leading: const CircleAvatar(
              child: Icon(
                Icons.link,
                color: kPrimaryColor,
              ),
            ),
            title: Text(
              selectedChurch!.fbHandle,
              style: primaryText(size: 15),
            ),
          ),
        if (selectedChurch!.iGHandle.isNotEmpty)
          ListTile(
            onTap: () {
              checkIfLink(selectedChurch!.iGHandle);
            },
            leading: const CircleAvatar(
              child: Icon(Icons.link),
            ),
            title: Text(
              selectedChurch!.iGHandle,
              style: primaryText(size: 15),
            ),
          ),
        AppButton(
          text: 'GIVE',
          textStyle: boldText(
            color: white,
            weight: FontWeight.w600,
            size: 16,
          ),
          color: kSecondaryColor,
          textColor: kPrimaryColor,
          width:
              MediaQuery.of(context).size.width - context.navigationBarHeight,
          onTap: () {
            if (isLoggedIn()) {
              const DonationScreen()
                  .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
            } else {
              toastLong('You must be logged in');
              const SignInScreen()
                  .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
            }
          },
        ).paddingSymmetric(vertical: 15, horizontal: 20),
        Row(
          children: [
            AppButton(
              text: 'OPEN MAP',
              textStyle: boldText(
                color: white,
                weight: FontWeight.w600,
                size: 16,
              ),
              color: kSecondaryColor,
              textColor: kPrimaryColor,
              width: MediaQuery.of(context).size.width -
                  context.navigationBarHeight,
              onTap: () {
                ChurchMapView(
                  churches: selectedChurch != null
                      ? [selectedChurch!]
                      : cachedChurches!,
                ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
              },
            ).expand(),
            10.width,
            AppButton(
              text: 'GET DIRECTIONS',
              textStyle: boldText(
                color: white,
                weight: FontWeight.w600,
                size: 16,
              ),
              color: kSecondaryColor,
              textColor: kPrimaryColor,
              width: MediaQuery.of(context).size.width -
                  context.navigationBarHeight,
              onTap: () {
                setLoading(true);
                buildFullAddressFromLatLong(
                        selectedChurch!.latitude, selectedChurch!.longitude)
                    .then((value) {
                  setLoading(false);
                  launchMap(value);
                });
              },
            ).expand()
          ],
        ).paddingSymmetric(horizontal: 20),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget searchResults() {
    return Text(
      'Search Results',
      style: primaryText(),
    ).paddingSymmetric(horizontal: 16).paddingBottom(20);
  }

  Widget searchResultList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: AnimatedListView(
        emptyWidget: NoDataWidget(
          title: 'No Data Found',
        ),
        itemCount: cachedChurches!.length,
        itemBuilder: (c, index) {
          final church = cachedChurches!.elementAt(index);

          final data = ListTile(
            onTap: () {
              setState(() {
                selectedChurch = church;
              });
            },
            title: Text(church.name, style: boldText(weight: FontWeight.w600)),
            subtitle: SnapHelperWidget(
              initialData: 'Loading...',
              errorBuilder: (p0) {
                return Text(p0, style: primaryText(size: 14));
              },
              defaultErrorMessage: 'No Address',
              future: buildFullAddressFromLatLong(
                  church.latitude, church.longitude),
              onSuccess: (data) {
                return Text(data, style: primaryText(size: 14));
              },
            ),
          );

          if (searching && searchResult.contains(church)) {
            return data;
          }

          if (!searching) return data;

          return const SizedBox();
        },
      ),
    );
  }
}
