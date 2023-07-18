/*
 * Copyright (C) 2015  David Edmundson <david@davidedmundson.co.uk>
 * Copyright (C) 2021  Reion Wong <reionwong@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

import QtQuick 2.12
import CuteUI 1.0 as CuteUI

/**
 * We need to draw a graph, all other libs are not suitable as we are basically
 * a connected scatter plot with non linear X spacing.
 * Currently this is not available in kdeclarative nor kqtquickcharts
 *
 * We only paint once, so canvas is fast enough for our purposes.
 * It is designed to look identical to those in ksysguard.
 */

Canvas {
    width: 500
    height: 500
    id: canvas
    antialiasing: true

    property int xPadding: 45
    property int yPadding: 40

    property var data //expect an array of QPointF

    property real yMax: 100
    property real xMax: 100
    property real yMin: 0
    property real xMin: 0
    property real yStep: 20

    property string yUnits: ""
    property string xUnits: ""

    property real xDuration: 3600
    property real xDivisions: 6
    property real xDivisionWidth: 600000
    property real xTicksAt: xTicksAtDontCare

    //internal

    property real plotWidth: width - xPadding * 1.5
    property real plotHeight: height - yPadding * 2

    onDataChanged: {
        canvas.requestPaint();
    }

    //take a QPointF
    function scalePoint(plot, currentUnixTime) {
        var scaledX = (plot.x - (currentUnixTime / 1000 - xDuration)) / xDuration * plotWidth;
        var scaledY = (plot.y - yMin)  * plotHeight / (yMax - yMin);

        return Qt.point(xPadding + scaledX,
            height - yPadding - scaledY);
    }

    property bool darkMode: CuteUI.Theme.darkMode
    property color textColor: CuteUI.Theme.textColor
    property color bgColor: CuteUI.Theme.secondBackgroundColor
    property color highlightColor: CuteUI.Theme.highlightColor

    onDarkModeChanged: {
        canvas.requestPaint()
    }

    onPaint: {
        var c = canvas.getContext('2d');

        c.clearRect(0,0, width, height)

        //draw the background
        c.fillStyle = bgColor
        c.fillRect(xPadding, yPadding, plotWidth, plotHeight);

        //reset for fonts and stuff
        c.fillStyle = textColor

        //Draw the lines
        c.lineWidth = 1;
        c.lineJoin = 'round';
        c.lineCap = 'round';
        c.strokeStyle = highlightColor
        var gradient = c.createLinearGradient(0, 0, 0, height);
        gradient.addColorStop(0, Qt.rgba(highlightColor.r, highlightColor.g, highlightColor.b, 0.2));
        gradient.addColorStop(1, Qt.rgba(highlightColor.r, highlightColor.g, highlightColor.b, 0.05));
        c.fillStyle = gradient;

        // For scaling
        var currentUnixTime = Date.now()
        var xMinUnixTime = currentUnixTime - xDuration * 1000

        // Draw the line graph
        c.beginPath();

        var index = 0

        while ((index < data.length - 1) && (data[index].x < (xMinUnixTime / 1000))) {
            index++
        }

        var firstPoint = scalePoint(data[index], currentUnixTime)
        c.moveTo(firstPoint.x, firstPoint.y)

        var point
        for (var i = index + 1; i < data.length; i++) {
            if (data[i].x > (xMinUnixTime / 1000)) {
                point = scalePoint(data[i], currentUnixTime)
                c.lineTo(point.x, point.y)
            }
        }

        // The data is empty.
        if (point === undefined)
            return

        c.stroke();
        c.strokeStyle = 'rgba(0, 0, 0, 0)';
        c.lineTo(point.x, height - yPadding);
        c.lineTo(firstPoint.x, height - yPadding);
        c.fill();

        c.closePath()

        // Draw the frame on top

        //draw an outline
//        c.strokeStyle = 'rgba(0,50,0,0.02)';
//        c.lineWidth = 1;
//        c.rect(xPadding - 1, yPadding - 1, plotWidth + 2, plotHeight + 2);

        // Draw the Y value texts
        c.fillStyle = textColor
        c.textAlign = "right"
        c.textBaseline = "middle";
        for(i = 0; i <=  yMax; i += yStep) {
            var y = scalePoint(Qt.point(0,i)).y;

            c.fillText(i + canvas.yUnits, xPadding - 10, y);

            //grid line
            c.moveTo(xPadding, y)
            c.lineTo(plotWidth + xPadding, y)
        }
        c.stroke()

        // Draw the X value texts
        c.textAlign = "center"
        c.lineWidth = 1
        c.strokeStyle = CuteUI.Theme.darkMode ? 'rgba(0, 0, 0, 0.35)' : 'rgba(0, 0, 0, 0.15)'

        var xDivisions = xDuration / xDivisionWidth * 1000
        var xGridDistance = plotWidth / xDivisions
        var xTickPos
        var xTickDateTime
        var xTickDateStr
        var xTickTimeStr

        var currentDateTime = new Date()
        var lastDateStr = currentDateTime.toLocaleDateString(Qt.locale(), Locale.ShortFormat)

        var hours = currentDateTime.getHours()
        var minutes = currentDateTime.getMinutes()
        var seconds = currentDateTime.getSeconds()

        var diff

        switch (xTicksAt) {
            case xTicksAtTwelveOClock:
                diff = ((hours - 12) * 60 * 60 + minutes * 60 + seconds)
                break
            case xTicksAtFullHour:
                diff = (minutes * 60 + seconds)
                break
            case xTicksAtFullSecondHour:
                diff = (minutes * 60 + seconds)
                break
            case xTicksAtHalfHour:
                diff = ((minutes - 30) * 60 + seconds)
                break
            case xTicksAtTenMinutes:
                diff = ((minutes % 10) * 60 + seconds)
                break
            default:
                diff = 0
        }

        var xGridOffset = plotWidth * (diff / xDuration)
        var dateChanged = false

        var dashedLines = 50
        var dashedLineLength = plotHeight / dashedLines
        var dashedLineDutyCycle

        for (i = xDivisions; i >= -1; i--) {
            xTickPos = i * xGridDistance + xPadding - xGridOffset

            if ((xTickPos > xPadding) && (xTickPos < plotWidth + xPadding)) {
                xTickDateTime = new Date(currentUnixTime - (xDivisions - i) * xDivisionWidth - diff * 1000)
                xTickDateStr = xTickDateTime.toLocaleDateString(Qt.locale(), Locale.ShortFormat)
                xTickTimeStr = xTickDateTime.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)

                if (lastDateStr !== xTickDateStr) {
                    dateChanged = true
                }

                if  ((i % 2 == 0) || (xDivisions < 10)) {
                    // Display the time
                    c.fillText(xTickTimeStr, xTickPos, canvas.height - yPadding / 2)

                    // If the date has changed and is not the current day in a <= 24h graph, display it
                    // Always display the date for 48h and 1 week graphs
                    if (dateChanged || (xDuration > (60*60*48))) {
                        c.fillText(xTickDateStr, xTickPos, canvas.height - yPadding / 4)
                        dateChanged = false
                    }

                    // Tick markers
                    c.moveTo(xTickPos, canvas.height - yPadding)
                    c.lineTo(xTickPos, canvas.height - (yPadding * 4) / 5)

                    dashedLineDutyCycle = 0.5
                } else {
                    dashedLineDutyCycle = 0.1
                }

                for (var j = 0; j < dashedLines; j++) {
                    c.moveTo(xTickPos, yPadding + j * dashedLineLength)
                    c.lineTo(xTickPos, yPadding + j * dashedLineLength + dashedLineDutyCycle * dashedLineLength)
                }
               lastDateStr = xTickDateStr
            }
        }
        c.stroke()
    }
}
