import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ImageUploadWidget extends StatefulWidget {
  XFile? img;
  Key key = new UniqueKey();
  Widget? button;

  ImageUploadWidget({Key? key, this.button}) : super(key: key);

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  XFile? img;
  final ImagePicker _picker = new ImagePicker();

  _ImageUploadWidgetState();

  @override
  Widget build(BuildContext context) {
    if (widget.button == null)
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          img == null
              ? Text("No Image")
              : Text(
                  "Image Uploaded",
                  style: TextStyle(color: Colors.green[400]),
                ),
          img == null
              ? TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 11),
                    backgroundColor: Colors.orange[100],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  ),
                  onPressed: _chooseImgSource,
                  child: Text("Upload Image"),
                )
              : ButtonBar(
                  buttonPadding: EdgeInsets.all(3),
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: _chooseImgSource,
                      icon: Icon(Icons.edit, color: Colors.grey),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        img = null;
                        refresh();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
        ],
      );
    else
      return GestureDetector(
        onTap: _chooseImgSource,
        child: widget.button!,
      );
  }

  void refresh() {
    setState(() {
      widget.img = img;
    });
  }

  Future<void> _chooseImgSource() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: double.maxFinite,
              width: MediaQuery.of(context).size.width * 0.4,
              child: IconButton(
                icon: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(child: Icon(Icons.camera)),
                    SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        'Camera',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
                onPressed: () async {
                  img = await _picker.pickImage(
                    source: ImageSource.camera,
                  );

                  Navigator.of(context).pop();

                  refresh();
                },
              ),
            ),
            Container(
              height: double.maxFinite,
              width: MediaQuery.of(context).size.width * 0.4,
              child: IconButton(
                icon: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(child: Icon(Icons.image)),
                    SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        'Gallery',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
                onPressed: () async {
                  img = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  Navigator.of(context).pop();

                  refresh();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
