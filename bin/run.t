  $ dune exec ../tests/test1.exe 
2>&1 | egrep -v "Gtk-Message|\":/q|qt.qpa.plugin|startup_stubs.cpp"
  
  Demo used to test ADT for qml code in module pr_qml!
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
  			text: "TEST1" + "TEST1"
  		}
  		id: rect1
  		width: 120
  		height: 60
  	}
  }
  $ dune exec ../tests/test2.exe 
2>&1 | egrep -v "Gtk-Message|\":/q|qt.qpa.plugin|startup_stubs.cpp"
  single func in OCaml
  quitting gui application
  $ dune exec ../tests/test3.exe 
2>&1 | egrep -v "Gtk-Message|\":/q|qt.qpa.plugin|startup_stubs.cpp"
  single func in OCaml
  quitting gui application
  $ dune exec ../tests/test4.exe 
2>&1 | egrep -v "Gtk-Message|\":/q|qt.qpa.plugin|startup_stubs.cpp"
  single func in OCaml
  quitting gui application
$ dune exec ../tests/test5.exe 
