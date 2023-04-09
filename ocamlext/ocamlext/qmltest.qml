import QtQuick 2.5
Rectangle
{
	id: rect2
	Image
	{
		id: image1
		x: 60
		y: 30
	}
	width: 640
	height: 480
	Rectangle
	{
		Text
		{
			id: text1
			x: 40
			y: 10
			text: "hi" + "you"
		}
		id: rect1
		width: 120
		height: 60
	}
}
