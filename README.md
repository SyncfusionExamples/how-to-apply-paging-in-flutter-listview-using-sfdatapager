# How to design and configure the Syncfusion Flutter datapager (SfDataPager) on Flutter ListView ?

Syncfusion Flutter Data Pager provide the build-in options to page data on demand and its more customizable and can be placed above or below on the requirement to easily manage data paging. The most important thing is we are the first to introduce the paging support for flutter list view.

## Step 1

```xml

Widget loadListView(BoxConstraints constraints) {
  List<Widget> _getChildren() {
    final List<Widget> stackChildren = [];

    if (_products.isNotEmpty) {
      stackChildren.add(ListView.custom(
          childrenDelegate: CustomSliverChildBuilderDelegate(indexBuilder)));
    }

    if (showLoadingIndicator) {
      stackChildren.add(Container(
        color: Colors.black12,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
      ));
    }
    return stackChildren;
  }

  return Stack(
    children: _getChildren(),
  );
}

@override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: Text('Fruits'),
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return Column(
          children: [
            Container(
              height: constraint.maxHeight - dataPagerHeight,
              child: loadListView(constraint),
            ),
            Container(
              height: dataPagerHeight,
              child: SfDataPagerTheme(
                  data: SfDataPagerThemeData(
                    itemBorderRadius: BorderRadius.circular(5),
                  ),
                  child: SfDataPager(
                      rowsPerPage: 10,
                      onPageNavigationStart: (pageIndex) {
                          setState(() {
                            showLoadingIndicator = true;
                          });
                       },
                      onPageNavigationEnd: (pageIndex) {
                          setState(() {
                            showLoadingIndicator = false;
                          });
                      },
                      delegate: CustomSliverChildBuilderDelegate(indexBuilder)
                        ..addListener(rebuildList))),
            )
          ],
        );
      }),
    ),
  );
}

```

## Step 2

Create a common delegate for both data pager and list view. Extent the SliverChildBuilderDelegate with DataPagerDelegate and ChangeNotifier to the data operation. 
	
* Override ‘childCount’ property from the SliverChildBuilderDelegate to set the defined length of child.
* Override rowCount property from DataPagerDelegate and set the total length of the data source.
* Override handlePageChange method to perform segmenting the data and loading the segmented data to the data pager.
* handlePageChange method will call every navigation between the pages

```xml

class CustomSliverChildBuilderDelegate extends SliverChildBuilderDelegate
    with DataPagerDelegate, ChangeNotifier {
  CustomSliverChildBuilderDelegate(builder) : super(builder);

  @override
  int get childCount => _paginatedProductData.length;

  @override
  int get rowCount => _products.length;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
      int startRowIndex, int rowsPerPage) async {
    int endIndex = startRowIndex + rowsPerPage;

    if (endIndex > _products.length) {
      endIndex = _products.length - 1;
    }

    await Future.delayed(Duration(milliseconds: 2000));
    _paginatedProductData = _products
        .getRange(startRowIndex, endIndex)
        .toList(growable: false);
    notifyListeners();
    return true;
  }

  @override
  bool shouldRebuild(covariant CustomSliverChildBuilderDelegate oldDelegate) {
    return true;
  }
}

```

## Step 3

Create an instance of the OrderInfoDataSource and assign that to DataGrid’s source and DataPager’s delegate properties.


```xml

List<PagingProduct> _paginatedProductData = [];

List<PagingProduct> _products = [];

bool showLoadingIndicator = false;

static const double dataPagerHeight = 70.0;

@override
void initState() {
  super.initState();
  _products = List.from(populateData());
}

void rebuildList() {
  setState(() {});
}

Widget loadListView(BoxConstraints constraints) {
  List<Widget> _getChildren() {
    final List<Widget> stackChildren = [];

    if (_products.isNotEmpty) {
      stackChildren.add(ListView.custom(
          childrenDelegate: CustomSliverChildBuilderDelegate(indexBuilder)));
    }

    if (showLoadingIndicator) {
      stackChildren.add(Container(
        color: Colors.black12,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
      ));
    }
    return stackChildren;
  }

  return Stack(
    children: _getChildren(),
  );
}

@override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: Text('Fruits'),
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return Column(
          children: [
            Container(
              height: constraint.maxHeight - dataPagerHeight,
              child: loadListView(constraint),
            ),
            Container(
              height: dataPagerHeight,
              child: SfDataPagerTheme(
                  data: SfDataPagerThemeData(
                    itemBorderRadius: BorderRadius.circular(5),
                  ),
                  child: SfDataPager(
                      rowsPerPage: 10,
                      onPageNavigationStart: (pageIndex) {
                          setState(() {
                            showLoadingIndicator = true;
                          });
                       },
                      onPageNavigationEnd: (pageIndex) {
                          setState(() {
                            showLoadingIndicator = false;
                          });
                      },
                      delegate: CustomSliverChildBuilderDelegate(indexBuilder)
                        ..addListener(rebuildList))),
            )
          ],
        );
      }),
    ),
  );
}

Widget indexBuilder(BuildContext context, int index) {
  final PagingProduct data = _paginatedProductData[index];
  return ListTile(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    title: LayoutBuilder(
      builder: (context, constraint) {
        return Container(
            width: constraint.maxWidth,
            height: 100,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(data.image, width: 100, height: 100),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: constraint.maxWidth - 130,
                        child: Text(data.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontSize: 15)),
                      ),
                      Container(
                        width: constraint.maxWidth - 130,
                        child: Text(data.weight,
                            style: TextStyle(
                                color: Colors.black87, fontSize: 10)),
                      ),
                      Container(
                        width: constraint.maxWidth - 130,
                        child: Row(
                          children: [
                            Container(
                              color: Colors.green.shade900,
                              padding: EdgeInsets.all(3),
                              child: Row(
                                children: [
                                  Text('${data.reviewValue}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13)),
                                  SizedBox(width: 2),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 15,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5),
                            Text('${data.ratings}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 11))
                          ],
                        ),
                      ),
                      Container(
                        width: constraint.maxWidth - 130,
                        child: Row(
                          children: [
                            Container(
                              child: Text('\$${data.price}',
                                  style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontSize: 13)),
                            ),
                            SizedBox(width: 8),
                            Text('${data.offer}',
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 10))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
      },
    ),
  );
}

```

