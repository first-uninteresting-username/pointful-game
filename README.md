# pointful-game

A pseud-arcade, very unfun game that has points (so it's not pointless). <!-- I'm very funny /joke -->

![Screenshot of the game](https://cdn.hackclub.com/01a1d5f5-8dfa-7d79-bd53-3f808fa92ee1/poinful-game.png)

**[Try it here](https://1stuninterestingusername.itch.io/pointful-game)**

## About

`pointful-game` is a game a made in preparation to Hack Club Haven.
It's only my second game and it's not fun to play at all.

## Features

- Growing points
- Losing
- Point destruction on contact with another point
- No sound or cool effects
- Probably one or two funny bugs that are totally intended

## Usage

- Space or the play button: start the game from the menu
- Left click a circle to pop it and gain points (smaller circles give more)
- Circles grow over time, when two touch, both vanish and you lose points
- Hold Space for 1 second to end the run early

The run ends when your score drops to 0. Your result is how long you survived.

## Running locally

This project uses [devenv](https://devenv.sh) for its development environment.

```bash
git clone https://github.com/first-uninteresting-username/pointful-game
cd pointful-game
devenv shell
```

Run `export-web` to export the game to web build.
It will be available at `$PWD/build/web`.


## Built with

- Godot 4

## How it works

The game tries to spawn a point every `min(1, 15/(time in seconds**1.3))` seconds.
This is a graph that describes this function:

![Graph stays flat, then drops quickly, like an inverted quadratic function.](https://cdn.hackclub.com/01a1d604-2a73-7441-9c3e-1147d8743570/desmos_graph_spawn_function_pointful_game.png)

I said it tries to spawn it, because if the selected coordinates are closer to any of existing point centers by radius of it in 1s (to avoid unfair situations).

When you click a point, it gets deleted and you get `max(200px/radius in pixels, 1)` points. For reference, points grow by 100 pixels every second.
This is a graph that describes this function:

![Graph drops steeply from the left, like 1/x, then stays flat at 1 from 200 pixels onward.](https://cdn.hackclub.com/01a1d698-6e76-768a-b5f4-5d64283ba99f/desmos_graph_click_score_pointful_game.png)

When two points touch each other, they both get deleted and you get `min(-2, -(radius of point A + radius of point B - 200 pixels)/50 - 2)` points.
This is a graph that describes this function:

![Graph stays flat at -2 until 200 pixels, then goes down in a straight line.](https://cdn.hackclub.com/01a1d698-7049-782b-a2de-7a04088c9adb/desmos_graph_collision_penalty_pointful_game.png)

## AI usage

- `AGENTS.md` is AI written
- `devenv.nix` is AI written
- The menu is copied over from my [previous game](https://github.com/first-uninteresting-username/you-are-the-ball) by AI
- I used AI heavily for explaining godot

## License

This project is licensed under the [GNU AGPL v3.0](LICENSE).
