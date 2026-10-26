// SPDX-License-Identifier: MIT
import QtQuick
import QtTest
import "../org.kde.ksysguard.simpletext/contents/ui" as SimpleText

TestCase {
    id: testCase
    name: "SimpleTextLayout"
    width: 400
    height: 200
    when: windowShown

    QtObject {
        id: settings
        property int columns: 1
        property int rowSpacing: 0
        property int columnSpacing: 12
        property int fontSize: 12
        property bool bold: false
        property bool monospace: true
        property bool stableWidth: true
        property int widthCharacters: 12
        property bool showEllipsis: true
        property string fontFamily: ""
        property bool italic: false
        property bool underline: false
        property int letterSpacing: 0
        property string textColor: ""
        property int alignment: 0
        property bool useSensorColors: false
        property string textFormat: "{value}"
    }

    QtObject {
        id: controller
        property var faceConfiguration: settings
        property var highPrioritySensorIds: ["simpletext-test/download", "simpletext-test/upload", "simpletext-test/third"]
        property var sensorColors: ({})
        property var sensorLabels: ({"simpletext-test/download": "Download", "simpletext-test/upload": "Upload"})
        property int updateRateLimit: 1000
    }

    SimpleText.TextGrid {
        id: view
        width: 400
        height: 200
        controller: controller
    }

    function init() {
        controller.highPrioritySensorIds = ["simpletext-test/download", "simpletext-test/upload", "simpletext-test/third"];
        settings.columns = 1;
        settings.fontSize = 12;
        settings.textFormat = "{value}";
        settings.stableWidth = true;
        settings.widthCharacters = 12;
        settings.italic = false;
        settings.underline = false;
        settings.textColor = "";
    }

    function test_stableWidthAndStyle() {
        const repeater = findChild(view, "readingsRepeater");
        tryCompare(repeater, "count", 3);
        const first = findChild(repeater.itemAt(0), "sensorReading");
        settings.textFormat = "12345 KiB/s";
        wait(0);
        const reservedWidth = view.implicitWidth;
        const reservedHeight = view.implicitHeight;
        settings.textFormat = "1 B/s";
        wait(0);
        compare(view.implicitWidth, reservedWidth);
        compare(view.implicitHeight, reservedHeight);
        settings.textFormat = "A much longer reading than the reserved space";
        wait(0);
        compare(view.implicitWidth, reservedWidth);
        settings.stableWidth = false;
        tryVerify(() => view.implicitWidth > reservedWidth);
        settings.textFormat = "1 B/s";
        tryVerify(() => view.implicitWidth < reservedWidth);
        settings.italic = true;
        settings.underline = true;
        settings.textColor = "#ff0000";
        tryCompare(first.font, "italic", true);
        compare(first.font.underline, true);
        compare(first.color, "#ff0000");
    }

    function test_overflow() {
        const repeater = findChild(view, "readingsRepeater");
        tryCompare(repeater, "count", 3);
        const first = findChild(repeater.itemAt(0), "sensorReading");
        settings.textFormat = "A reading that is too long to fit";
        settings.showEllipsis = true;
        tryCompare(first, "elide", Text.ElideRight);
        const width = view.implicitWidth;
        settings.showEllipsis = false;
        tryCompare(first, "elide", Text.ElideNone);
        verify(first.clip);
        compare(view.implicitWidth, width);
        settings.showEllipsis = true;
    }

    function test_layoutAndFormat() {
        const grid = findChild(view, "readingsGrid");
        const repeater = findChild(view, "readingsRepeater");
        tryCompare(repeater, "count", 3);
        const first = findChild(repeater.itemAt(0), "sensorReading");
        const second = repeater.itemAt(1);
        const third = repeater.itemAt(2);
        tryVerify(() => second.y > repeater.itemAt(0).y);
        compare(repeater.itemAt(0).x, second.x);

        settings.columns = 2;
        tryVerify(() => second.x > repeater.itemAt(0).x);
        compare(repeater.itemAt(0).y, second.y);
        tryVerify(() => third.y > repeater.itemAt(0).y);

        settings.textFormat = "{name}: {value}";
        tryVerify(() => first.text.startsWith("Download: "));
        verify(findChild(second, "sensorReading").text.startsWith("Upload: "));
        settings.fontSize = 22;
        tryCompare(first.font, "pointSize", 22);

        controller.highPrioritySensorIds = [];
        tryCompare(repeater, "count", 0);
        compare(grid.columns, 1);
    }
}
