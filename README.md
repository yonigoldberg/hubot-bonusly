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
You need to be a user of https://bonus.ly to use this.

You can find the API token to set in `HUBOT_BONUSLY_ADMIN_API_TOKEN` at https://bonus.ly/api. Make sure you log in as a Bonusly admin user to get a admin token.

## Installation
Install this using NPM. Simply:

Include `hubot-bonusly` as a dependency in `package.json` e.g.
```
  "dependencies": {
    "hubot": ">= 2.6.0 < 3.0.0",
    [ lines deleted ]
    "hubot-bonusly": ""
  }
```

Add `hubot-bonusly` to your `external-scripts.json` file e.g.
```
["hubot-foobar", "hubot-bonusly"]
```

## Author
[doofdoofsf](https://github.com/doofdoofsf)
