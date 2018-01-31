import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: appWindow
    visible: true
    width: 860
    height: 640
    title: qsTr("QML Pong")

    property real leftPosition: 0.45
    property real rightPosition: 0.45
    property real step: 0.02

    property int leftMoving: 0
    property int rightMoving: 0

    property real ballVelX: 0
    property real ballVelY: 0
    property real ballSpeed: 0.01
    property real ballPosX: 0.5
    property real ballPosY: 0.5

    property int leftPlayerScore: 0
    property int rightPlayerScore: 0


    function resetBall() {
        ballVelX = 0
        ballVelY = 0
        ballPosX = 0.5
        ballPosY = 0.5
    }

    Timer {
        id: inputHandler
        running: true
        repeat: true
        interval: 20

        onTriggered: {
            leftPosition += step * leftMoving
            rightPosition += step * rightMoving

            var maxPlayerPos = (appWindow.height - leftPlayer.height)/appWindow.height

            if(leftPosition > maxPlayerPos) leftPosition = maxPlayerPos
            if(leftPosition < 0) leftPosition = 0
            if(rightPosition > maxPlayerPos) rightPosition = maxPlayerPos
            if(rightPosition < 0) rightPosition = 0

            if (ballVelX === 0 && ballVelY === 0) {
                if(Math.random() > 0.5)
                    ballVelX =  0.75
                else
                    ballVelX = -0.75
                ballVelY = 2*(Math.random() - 0.5)
            }

            ballPosX += ballVelX*ballSpeed
            ballPosY += ballVelY*ballSpeed

            var maxBallPosX = (appWindow.width - ball.width)/appWindow.width
            var maxBallPosY = (appWindow.height - ball.height)/appWindow.height
            var ballCenterY = ball.y + ball.height/2

            if(ball.x < leftPlayer.x+leftPlayer.width) { //check left player collision
                if(ball.x < -ball.width/2) {
                    rightPlayerScore+=1
                    resetBall()
                    return
                }

                if(ball.y+ball.height > leftPlayer.y && ball.y < leftPlayer.y+leftPlayer.height) {
                    var left_pCenterY = leftPlayer.y + leftPlayer.height/2
                    var left_yCenterVec = (ballCenterY - left_pCenterY) / (leftPlayer.height/2 + ball.height/2)

                    ballVelX *= -1.05
                    ballVelY = 0.25*ballVelY + 0.75*left_yCenterVec
                }

            }

            if(ball.x+ball.width > rightPlayer.x) { //check right player collision

                if(ball.x > appWindow.width) {
                    leftPlayerScore+=1
                    resetBall()
                    return
                }

                if(ball.y+ball.height > rightPlayer.y && ball.y < rightPlayer.y+rightPlayer.height) {
                    var right_pCenterY = rightPlayer.y + rightPlayer.height/2
                    var right_yCenterVec = (ballCenterY - right_pCenterY) / (rightPlayer.height/2 + ball.height/2)

                    ballVelX *= -1.05
                    ballVelY = 0.25*ballVelY + 0.75*right_yCenterVec
                }



            }


            //if(ballPosX < 0 || ballPosX > maxBallPosX) ballVelX *= -1
            if(ballPosY < 0 || ballPosY > maxBallPosY) ballVelY *= -1
        }
    }

    Rectangle {
        id: root
        anchors.fill: parent
        color: "black"
        focus: true



        Rectangle {
            id: scoreBoard
            anchors.top: parent.top

            width: 200
            height: 80
            x: appWindow.width/2 - width/2

            color: "black"

            Label {
                anchors.fill: parent

                color: "white"


                text: leftPlayerScore + " - " + rightPlayerScore
                font.bold: true
                font.pointSize: 30
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }



        }

        Rectangle {
            id: leftPlayer
            anchors.left: parent.left
            anchors.leftMargin: 12
            height: appWindow.width / 12
            width: width = height / 5
            y: leftPosition * appWindow.height


        }

        Rectangle {
            id: rightPlayer
            anchors.right: parent.right
            anchors.rightMargin: 12
            height: leftPlayer.height
            width: leftPlayer.width
            y: rightPosition * appWindow.height
        }

        Rectangle {
            id: ball
            width: appWindow.width / 30
            height: width
            radius: 0.5 * width

            color: "white"

            x: ballPosX * appWindow.width
            y: ballPosY * appWindow.height
        }


        Keys.onPressed: {
            if(event.key === Qt.Key_W)    leftMoving  = -1
            if(event.key === Qt.Key_S)    leftMoving  = 1
            if(event.key === Qt.Key_Up)   rightMoving = -1
            if(event.key === Qt.Key_Down) rightMoving = 1
        }

        Keys.onReleased: {
            if(event.key === Qt.Key_W || event.key === Qt.Key_S)     leftMoving  = 0
            if(event.key === Qt.Key_Up || event.key === Qt.Key_Down) rightMoving = 0
        }
    }

}
