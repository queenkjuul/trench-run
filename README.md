# trench-run

A weekend project to learn Godot

you can play it at [queenkjuul.xyz/trench](https://queenkjuul.xyz/trench)

Assets are not included, so you won't be able to build this repo directly.

Written in Godot 3.5 for maximum web compatibility (and the version Ubuntu ships, conveniently)

Godot output is wrapped in a simple Svelte app to show leaderboards

High scores are saved to my server: [trench-run-high-scores](https://github.com/queenkjuul/trench-run-high-scores)

## Backstory

In the early 2000s, my uncle was a web designer, and I got to playing around with Flash 5 when I would visit. Eventually he just gave me his copy of it, and I spent a lot of time making animations. It wasn't until I was a little older, maybe 12-13, that I started to dabble in ActionScript and trying to make a game, rather than just cartoons. My first attempt at a game was a pseudo-first-person, pseudo-3D death star trench run game, where TIE fighters would swoop into the trench and you'd have to click on them to kill them.

I never really finished the project, and with a small class project exception, never really worked on anything resembling a game ever again. I didn't do any programming at all basically between the ages of 14 and 28. So having seen some videos about Godot on youtube, and how simple it looked to get running, I decided to try it out, and a reimagining of that childhood project was what I decided to do.

## A note on encryption

The deployed version of the game is GDScript encrypted, and data is encrypted before transmit to the high score server. This is an incredibly jank and insecure encryption setup, not meant to be a demonstration of best practice, but simply an obstacle for my friend who said she'd try and post fake high scores. Godot 3.5 only supports mediocre encryption methods, and I don't understand how to do some kind of fancy D-H key exchange thing.
