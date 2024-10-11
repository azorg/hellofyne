// File: "hellofyne.go"

package main

import (
	"fyne.io/fyne/v2" // fyne
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/widget"
)

func main() {
	a := app.New()
	
	w := a.NewWindow("Hello World")
	w.Resize(fyne.NewSize(240, 50))
	w.SetContent(widget.NewLabel("Hello World!"))

	w.Show()
	a.Run()
}

// EOF: "hellofyne.go"
