# Rival Showdown: Gun's Blazing
## Offline Version

This is an offline implementation of the game **Rival Showdown: Gun's Blazing** that I created as a school project along with my partners: **Jacob, Jonathan, and Paul.** Since the original game was designed to be an online game, there are some decisions that need to be made to allow this game to be played on a single computer.

**The git repository for the original game is set to private**

**Here is the link for those who have access to it: [https://git.lindblom.tech/JefferyC/Rival_Showdown.git](https://git.lindblom.tech/JefferyC/Rival_Showdown.git)**

## Key Bindings

Before playing, make sure the key bindings are set to what you want it to be. To set the key bindings, you must navigate to **/RivalShowdown/res/gameData/keyBindings.txt** to modify the file. There should be a key code for each key on your keyboard. To find out what the key code is, you can <span style="color: red">open up a processing sketch and print out the key codes</span> OR <span style="color: red">add "println(keyCode)" to the keyPressed method in this game to print out the keyCode</span>.

**Make sure to not modify any other files inside the "res" folder unless you know what you are doing or are told otherwise. Some of the other files may not be very flexible and may result in the game crashing**

## Warning

The stats for each of the characters are not properly tested, so there is definitely some characters that are more overpowered compared to other characters.

## Bugs

Since this is the first version of this game, it is likely littered with bugs. Some of which I have encountered are:

* Some key press and release events are not registered and the key need to be pressed again in order for the key event to be recorded.

