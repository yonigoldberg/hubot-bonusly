hubot-bonusly
=============

Hubot Bonusly integration (employee recognition with micro-bonuses)

## Config
### Required
HUBOT_BONUSLY_ADMIN_API_TOKEN

## Commands
-  `hubot give <amount> to <name|email> for <reason> <#hashtag>` - gives a micro-bonus to the specified user
-  `hubot bonuses` - lists recent micro-bonuses

## Notes
You can find your API token at https://bounus.ly/api

## Installation
Install this using NPM. Simply:

1. Include `hubot-bonusly` as a dependency in `package.json` e.g.

```
  "dependencies": {
    "hubot": ">= 2.6.0 < 3.0.0",
    [ lines deleted ]
    "hubot-bonusly": ""
  }
```

2. Add `hubot-bonusly` to your `external-scripts.json` file e.g.
```
["hubot-foobar", "hubot-bonusly"]
```

## Author
[doofdoofsf](https://github.com/doofdoofsf)
