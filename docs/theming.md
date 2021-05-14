# Theming EgoVenture

## Introduction

*EgoVenture* games typically feature a lot of images and graphics. All aspects of the game look can be customized using Godot's [theming features](https://docs.godotengine.org/en/stable/tutorials/gui/gui_skinning.html).

A starter theme resource called _theme.tres_ is already available in the *EgoVenture game template*.

This document describes the available theming settings.

## Basic anatomy of the theme

Upon opening _theme.tres_ using the file system browser in Godot, the inspector shows the theme like this:

<img title="" src="file:///Users/dennis.ploeger/Library/Mobile Documents/com~apple~CloudDocs/Dennis/Hobbies/games/MDNA/images/0c722878cae5ee36d9a82e5babd7fc03f5f3e25d.png" alt="The theme options" data-align="center">

The theme is categorized in different UI element types. Throughout the game, different aspects use different UI elements to achieve the desired result.

Additionally, the game uses Godot's default dialog boxes for confirmation and messages. Because of this, not only special game features are included in the theme.

In this document, each category and setting is described.

## Default Font

The default font that is used throughout the game

## Button

| Subcategory | Setting              | Description                                          | Used in          |
| ----------- | -------------------- | ---------------------------------------------------- | ---------------- |
| Colors      | Font Color           | Color of the text on default buttons                 | Standard Dialogs |
|             | Font Color Disabled  | Color of the text when a button is disabled          | Standard Dialogs |
|             | Font Color Hover     | Color of the text when hovering over default buttons | Standard Dialogs |
|             | Font Color Pressed   | Color of the text when pressing default buttons      | Standard Dialogs |
| Fonts       | Menu Button          | Font for menu buttons                                | Main menu        |
|             | Menu Button Hover    | Font for menu buttons when hovered                   | Main menu        |
| Styles      | Focus                | Fill style of default buttons                        | Standard Dialogs |
|             | Hover                | Fill style used when hovering over default buttons   | Standard Dialogs |
|             | Menu Button Disabled | Fill style of menu buttons when disabled             | Main menu        |
|             | Menu Button Hover    | Fill style of menu buttons when hovered              | Main menu        |
|             | Menu Button Normal   | Fill style of menu buttons                           | Main menu        |
|             | Menu Button Pressed  | Fill style of pressed menu buttons                   | Main menu        |
|             | Normal               | Fill style of default buttons                        | Standard Dialogs |
|             | Pressed              | Fill style of default buttons                        | Standard Dialogs |

## Check Button

Used in the game options for the "Subtitles"-setting

| Subcategory | Setting       | Description                                             | Used in      |
| ----------- | ------------- | ------------------------------------------------------- | ------------ |
| Icons       | Off           | The unchecked state image of the check button           | Game options |
|             | On            | The checked state image of the check button             | Game options |
| Styles      | Focus         | Fill style when the check button is focused             | Game options |
|             | Hover         | Fill style when the check button is hovered             | Game options |
|             | Hover Pressed | Fill style when the check button is hovered and checked | Game options |
|             | Normal        | Fill style for the check button                         | Game options |
|             | Pressed       | Fill style for the check button is pressed              | Game options |

## H Slider

Used in the game options for the "Volume"-settings

| Subcategory | Setting                | Description                                                  | Used in      |
| ----------- | ---------------------- | ------------------------------------------------------------ | ------------ |
| Icons       | Grabber                | The image used for the grabber in the slider                 | Game options |
|             | Grabber Highlight      | The image used for the grabber when the slider is highlighted | Game options |
|             | Tick                   | The image used for the ticks in the slider                   | Game options |
| Styles      | Grabber Area           | The fill for the grabber area                                | Game options |
|             | Grabber Area Highlight | The fill for the grabber area when highlighted               | Game options |
|             | Slider                 | The fill for the slider                                      | Game options |

## Label

| Subcategory | Setting                | Description                                                  | Used in        |
| ----------- | ---------------------- | ------------------------------------------------------------ | -------------- |
| Colors      | Detail View Font Color | The font color of the detail view description                | Detail View    |
|             | Font Color             | The font color of various items (based on labels) like the date labels, the menu titles, etc. | Various places |
|             | Goals                  | The font color of the goals in the notepad                   | Notepad        |
|             | Hints                  | The font color of the hints in the notepad                   | Notepad        |
| Fonts       | Detail View            | The font used for the description in the detail view         | Detail view    |
|             | Goals                  | The font used for the goals in the notepad                   | Notepad        |
|             | Hints                  | The font used for the hints in the notepad                   | Notepad        |

## Panel

| Subcategory | Setting         | Description                                           | Used in     |
| ----------- | --------------- | ----------------------------------------------------- | ----------- |
| Styles      | Detail View     | The background used in the inventory item detail view | Detail view |
|             | Dialog Panel    | The background used in the Parrot dialogs             | Dialogs     |
|             | Inventory Panel | The background of the inventory panel                 | Inventory   |
|             | Notepad Panel   | The background behind the image of the notepad        | Notepad     |
|             | Saveslot Panel  | The design of an empty saveslot                       | Save Slots  |

## Progress Bar

| Subcategory | Setting | Description                             | Used in        |
| ----------- | ------- | --------------------------------------- | -------------- |
| Styles      | Bg      | The background of the progress bar      | Loading screen |
|             | Fg      | The foreground fill of the progress bar | Loading screen |

## Rich Text Label

| Subcategory | Setting                         | Description                                                                 | Used in         |
| ----------- | ------------------------------- | --------------------------------------------------------------------------- | --------------- |
| Colors      | Dialog Hotspot Asked Font Color | The color of the font when a question of a dialog hotspot was already asked | Dialog Hotspots |
|             | Dialog Hotspot Hover Font Color | The color of the font when a dialog hotspot is hovered                      | Dialog Hotspots |
|             | Dialog Hotspot Font Color       | The normal color of the dialog hotspot font                                 | Dialog Hotspots |
| Fonts       | Dialog Font                     | Font used in the parrot dialogs                                             | Dialogs         |
|             | Dialog Hotspot Bold Font        | Bold font used in dialog hotspots                                           | Dialog Hotspots |
|             | Dialog Hotspot Normal Font      | Normal font used in dialog hotspots                                         | Dialog Hotspots |

## Window Dialog

| Subcategory | Setting         | Description                                                                                                      | Used in          |
| ----------- | --------------- | ---------------------------------------------------------------------------------------------------------------- | ---------------- |
| Icons       | Close           | The icon used as a close icon in dialog boxes. Should be set to an empty image as we're not using it             | Standard dialogs |
|             | Close Highlight | The icon used as a highlighted close icon in dialog boxes. Should be set to an empty image as we're not using it | Standard dialogs |
| Styles      | Panel           | The window panel                                                                                                 |                  |