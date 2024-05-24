import 'package:flutter/material.dart';

class CreateNotePage extends StatelessWidget {
  const CreateNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Create A Note",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Clear",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const TextField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                label: Text("Enter Name"),
                hintText: "Name",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text("Enter Principal Amount"),
                      hintText: "100000",
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text("Interest Rate"),
                      hintText: "In rupees",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Pick A Date",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Expanded(
                  flex: 2,
                  child: TextField(
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: "dd/mm/yyyy",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(double.infinity, double.minPositive),
                backgroundColor: const Color(0xFF8B3DFF),
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Upload Images',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.image, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Image Name',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.cancel,
                  ),
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.green),
                ),
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Save Note",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
