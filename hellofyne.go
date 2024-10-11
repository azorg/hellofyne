// File: "hellofyne.go"

package main

import (
	"log"
	"os"
	"time"

	"fyne.io/fyne/v2" // fyne
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/layout"
	"fyne.io/fyne/v2/widget"
)

func main() {
	//os.Setenv("FYNE_SCALE", "0.8") // FIXME
	a := app.New()

	// Create window
	w := a.NewWindow("Hello Fyne!")
	w.Resize(fyne.NewSize(640, 480))

	// Create widgets
	label := widget.NewLabel("Hello World!")
	label.TextStyle.Bold = true

	entry := widget.NewEntry()
	entry.TextStyle.Monospace = true
	entry.MultiLine = true

	btnQuit := widget.NewButton("Quit", func() {
		log.Print("button Quit pressed")
		a.Quit()
		os.Exit(0)
	})

	btnDo := widget.NewButton("Do", func() {
		msg := "button Do pressed"
		log.Print(msg)
		text := entry.Text + time.Now().Format(time.DateTime) + " " + msg + "\n"
		entry.SetText(text)
	})

	btnClear := widget.NewButton("Clear", func() {
		log.Print("button Clear pressed")
		entry.SetText("")
	})

	// Create containers/spacers/layout
	spacer := layout.NewSpacer
	vbox := container.NewBorder(
		container.NewCenter(label),                            // top
		container.NewHBox(btnDo, btnClear, spacer(), btnQuit), // bottom
		nil, nil, // left, right
		entry, // center
	)

	// Show window and run
	w.SetContent(vbox)
	w.Show()
	a.Run()
}

// EOF: "hellofyne.go"
