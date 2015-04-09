# galehx
Gale haXe is a 2d game framework written in haXe.
It handles everything from the game loop, rendering, sound, input, and game object handling.

Features
  * High performance 2D rendering using bitmap blitting.
  * Ability to use MovieClips attached to layers which allows bitmaps and MovieClips to be rendered in different orders.
  * Spatial sound for more realistic in-game sounds.
  * Inputs with hotkey support allows for multiple keys bound to a single hotkey.
  * Separate loop for logic and rendering allows for separate timing.
  * Node as the main game object used for components included in the framework.
  * Entity as the main display object that is attached to a node. A node may have multiple entities.
  * Dynamic transforms for entities allows for rapid prototyping and provides great performance by caching the transforms lazily.
  * Inheritance support for nodes to add specific functionality to game objects.
  * Component support for nodes which allows for lower coupling when adding functionality to game objects.
  * Export as a MovieClip which can be embedded in an AS3 project when one requires AS3 components.
  * Export as a SWC library which allows for the game specific logic to be written in AS3 while the framework handles everything else.
