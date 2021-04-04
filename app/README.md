# The Hunt

Gunnar är bäst!!!

## Getting Started

- open the workspace file in VS Code.
- install recommended extensions (at least flutter)
- go to run tab
- run the app (preferably on a device)

## TODO:
- IMPORTANT: Refactor the reveals so they are two computed lists with passed and unpassed revealmoments. This way we can avoid recalculating a LOT on every second.

- Make sure app isn't crashing on no internet conncection (dio.error uncaught exception)
- leave /destroy game when user leaves it.
- sometimes when creating game the playerName is blank in the lobby
- Make revealmoments saved in parse so game master can change dynamically.
- make create, join and start game snappy! Now very slow doing a lot of async stuff
- handle so there can't be several subscription triggers. (seems to happen on hot reload sometimes)