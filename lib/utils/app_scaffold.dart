import 'package:flutter/material.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
    this.isLoading = false,
    this.appBar,
    this.floatingActionButton,
    this.isUnavailableFeatureScreen = false,
    this.bottomsheet,
    this.bottomAppBar,
  });

  final Widget body;
  final Color? backgroundColor;
  final bool isLoading;
  final PreferredSizeWidget? appBar;
  final Widget? bottomsheet;
  final Widget? floatingActionButton, bottomAppBar;
  final bool isUnavailableFeatureScreen;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      bottomSheet: widget.bottomsheet,
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: widget.bottomAppBar,
      appBar: widget.appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.body,
          if (widget.isLoading)
            Container(
              color: Colors.black.withOpacity(.2),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            const SizedBox.shrink()
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.title,
      this.leading,
      this.actions,
      this.backgroundColor,
      this.centerTitle,
      this.toolbarHeight,
      this.flexibleSpace,
      this.bottom,
      this.leadingWidth,
      this.isLoading = false});
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool? centerTitle;
  final bool isLoading;
  final double? toolbarHeight;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? leadingWidth;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      flexibleSpace: flexibleSpace,
      backgroundColor: isLoading
          ? (backgroundColor == null || backgroundColor == Colors.white)
              ? Colors.black.withOpacity(.2)
              : backgroundColor!
          : backgroundColor,
      leadingWidth: leadingWidth,
      title: title,
      leading: leading,
      bottom: bottom,
      actions: actions != null
          ? [
              ...actions!.map((action) => AbsorbPointer(
                    absorbing: isLoading,
                    child: action,
                  ))
            ]
          : actions,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
